//
//  UploadAnswerViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 28.09.2021.
//

import SwiftUI
import Firebase
import OneSignal

class UploadAnswerViewModel: ObservableObject {
    @Published var loadingNow: Bool = false
    @Binding var isPresented: Bool
    @Binding var answerUploaded: Bool
    let question: Question
    
    init(question: Question, isPresented: Binding<Bool>, answerUploaded: Binding<Bool>) {
        self.question = question
        self._isPresented = isPresented
        self._answerUploaded = answerUploaded
    }
    
    func answerQuestion(caption: String) {
        guard let user = AuthViewModel.shared.user else { return }
        let docRef = COLLECTION_QUESTIONS.document(self.question.id).collection("question-answers").document(user.id).collection("user-answers").document()
        
        
        let data: [String: Any] = [
            "uid": user.id,
            "caption": caption,
            "fullname": user.fullname,
            "timestamp": Timestamp(date: Date()),
            "username": user.username,
            "solution": 0,
            "profileImageUrl": user.profileImageUrl,
            "likes": 0,
            "id": docRef.documentID
        ]
        
        
        COLLECTION_QUESTIONS.document(self.question.id).collection("question-answers").document(user.id).setData([:]) { _ in
            COLLECTION_QUESTIONS.document(self.question.id).collection("question-answers").document(user.id).collection("user-answers").document(docRef.documentID).setData(data) { _ in
                self.isPresented = false
                self.loadingNow = false
                self.answerUploaded = true
            }
        }
        
        
        let repliesRef = COLLECTION_QUESTIONS.document(self.question.id)
        
        repliesRef.getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            guard let repliesCount = data["answers"] as? Int else { return }
            
            repliesRef.updateData(["answers": repliesCount + 1]) { _ in
                
            }
            
        }
             
        
        if user.id != self.question.uid {
            let userNotifRef = COLLECTION_USERS.document(self.question.uid).collection("user-notifications").document("answer-\(self.question.id)")
            
            userNotifRef.getDocument { snapshot, _ in
                guard let userGotThisNotif = snapshot?.exists else { return }
                if userGotThisNotif {
                    guard let data = snapshot?.data() else { return }
                    guard let senderUid = data["senderUid"] as? String else { return }
                    if senderUid != user.id {
                        let notificationData: [String: Any] = [
                            "isRead": 0,
                            "notifyType": "answer",
                            "tweetID": self.question.id,
                            "senderUsername": user.username,
                            "senderUid": user.id,
                            "timestamp": Timestamp(date: Date()),
                            "senderFullname": user.fullname,
                            "senderCaption": caption,
                            "senderProfileImageUrl": user.profileImageUrl,
                            "id": userNotifRef.documentID
                        ]
                        
                        userNotifRef.setData(notificationData) { _ in
                            COLLECTION_USERS.document(self.question.uid).getDocument { snapshot, _ in
                                guard let data = snapshot?.data() else { return }
                                guard let targetPlayerId = data["playerId"] as? String else { return }
                                OneSignal.postNotification(["contents": ["en": "\(user.fullname) answered your question!"], "include_player_ids": [targetPlayerId]])
                            }
                        }
                    }
                } else {
                    let notificationData: [String: Any] = [
                        "isRead": 0,
                        "notifyType": "answer",
                        "tweetID": self.question.id,
                        "senderUsername": user.username,
                        "senderUid": user.id,
                        "timestamp": Timestamp(date: Date()),
                        "senderFullname": user.fullname,
                        "senderCaption": caption,
                        "senderProfileImageUrl": user.profileImageUrl,
                        "id": userNotifRef.documentID
                    ]
                    
                    userNotifRef.setData(notificationData) { _ in
                        COLLECTION_USERS.document(self.question.uid).getDocument { snapshot, _ in
                            guard let data = snapshot?.data() else { return }
                            guard let targetPlayerId = data["playerId"] as? String else { return }
                            OneSignal.postNotification(["contents": ["en": "\(user.fullname) answered your question!"], "include_player_ids": [targetPlayerId]])
                        }
                    }
                }
            }
        }
    }
    
    
    func answerQuestionWithImage(caption: String, selectedImage: UIImage) {
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(filename)
        
        DispatchQueue.main.async {
            storageRef.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    print("DEBUG: Failed to upload image for tweet \(error.localizedDescription)")
                    return
                }

                storageRef.downloadURL { url, _ in
                    guard let imageUrl = url?.absoluteString else { return }
                
                    guard let user = AuthViewModel.shared.user else { return }
                    let docRef = COLLECTION_TWEETS.document(self.question.id).collection("question-answers").document(user.id).collection("user-answers").document()
                    
                    
                    let data: [String: Any] = [
                        "uid": user.id,
                        "caption": caption,
                        "fullname": user.fullname,
                        "timestamp": Timestamp(date: Date()),
                        "username": user.username,
                        "solution": 0,
                        "profileImageUrl": user.profileImageUrl,
                        "imageUrl": imageUrl,
                        "likes": 0,
                        "id": docRef.documentID
                    ]
                    
                    COLLECTION_QUESTIONS.document(self.question.id).collection("question-answers").document(user.id).setData([:]) { _ in
                        COLLECTION_QUESTIONS.document(self.question.id).collection("question-answers").document(user.id).collection("user-answers").document(docRef.documentID).setData(data) { _ in
                            self.isPresented = false
                            self.loadingNow = false
                            self.answerUploaded = true
                        }
                    }
                    
                    let repliesRef = COLLECTION_QUESTIONS.document(self.question.id)
                    
                    repliesRef.getDocument { snapshot, _ in
                        guard let data = snapshot?.data() else { return }
                        guard let repliesCount = data["answers"] as? Int else { return }
                        
                        repliesRef.updateData(["answers": repliesCount + 1]) { _ in
                            
                        }
                        
                    }
                    
                    if user.id != self.question.uid {
                        let userNotifRef = COLLECTION_USERS.document(self.question.uid).collection("user-notifications").document("answer-\(self.question.id)")
                        
                        userNotifRef.getDocument { snapshot, _ in
                            guard let userGotThisNotif = snapshot?.exists else { return }
                            if userGotThisNotif {
                                guard let data = snapshot?.data() else { return }
                                guard let senderUid = data["senderUid"] as? String else { return }
                                if senderUid != user.id {
                                    let notificationData: [String: Any] = [
                                        "isRead": 0,
                                        "notifyType": "answer",
                                        "tweetID": self.question.id,
                                        "senderUsername": user.username,
                                        "senderUid": user.id,
                                        "timestamp": Timestamp(date: Date()),
                                        "senderFullname": user.fullname,
                                        "senderCaption": caption,
                                        "senderProfileImageUrl": user.profileImageUrl,
                                        "senderImageUrl": imageUrl,
                                        "id": userNotifRef.documentID
                                    ]
                                    
                                    userNotifRef.setData(notificationData) { _ in
                                        COLLECTION_USERS.document(self.question.uid).getDocument { snapshot, _ in
                                            guard let data = snapshot?.data() else { return }
                                            guard let targetPlayerId = data["playerId"] as? String else { return }
                                            OneSignal.postNotification(["contents": ["en": "\(user.fullname) answered your question!"], "include_player_ids": [targetPlayerId]])
                                        }
                                    }
                                }
                            } else {
                                let notificationData: [String: Any] = [
                                    "isRead": 0,
                                    "notifyType": "answer",
                                    "tweetID": self.question.id,
                                    "senderUsername": user.username,
                                    "senderUid": user.id,
                                    "timestamp": Timestamp(date: Date()),
                                    "senderFullname": user.fullname,
                                    "senderCaption": caption,
                                    "senderProfileImageUrl": user.profileImageUrl,
                                    "senderImageUrl": imageUrl,
                                    "id": userNotifRef.documentID
                                ]
                                
                                userNotifRef.setData(notificationData) { _ in
                                    COLLECTION_USERS.document(self.question.uid).getDocument { snapshot, _ in
                                        guard let data = snapshot?.data() else { return }
                                        guard let targetPlayerId = data["playerId"] as? String else { return }
                                        OneSignal.postNotification(["contents": ["en": "\(user.fullname) answered your question!"], "include_player_ids": [targetPlayerId]])
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
                
    }
}
