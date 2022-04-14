//
//  UploadQuestionViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 28.09.2021.
//

import SwiftUI
import Firebase

class UploadQuestionViewModel: ObservableObject {
    @Published var loadingNow: Bool = false
    @Binding var isPresented: Bool
    @Binding var questionUploaded: Bool
    
    init(isPresented: Binding<Bool>, questionUploaded: Binding<Bool>) {
        self._isPresented = isPresented
        self._questionUploaded = questionUploaded
    }
    
    func uploadQuestion(title: String, caption: String, gameName: String) {
        guard let user = AuthViewModel.shared.user else { return }
        let docRef = COLLECTION_QUESTIONS.document()
        
        let data: [String: Any] = [
            "uid": user.id,
            "title": title,
            "caption": caption,
            "gameName": gameName,
            "fullname": user.fullname,
            "timestamp": Timestamp(date: Date()),
            "username": user.username,
            "profileImageUrl": user.profileImageUrl,
            "status": 0,
            "likes": 0,
            "answers": 0,
            "id": docRef.documentID
        ]
        

        docRef.setData(data) { _ in
            
            guard let uid = AuthViewModel.shared.userSession?.uid else { return }
            let userTweetsRef = COLLECTION_USERS.document(uid).collection("user-questions")
            userTweetsRef.document(docRef.documentID).setData([:]) { _ in
                self.isPresented = false
                self.loadingNow = false
                self.questionUploaded = true
            }
                
        }
    }
    
    func uploadQuestionWithImage(title: String, caption: String, gameName: String, selectedImage: UIImage) {
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
                    let docRef = COLLECTION_QUESTIONS.document()
                    
                    let data: [String: Any] = [
                        "uid": user.id,
                        "title": title,
                        "caption": caption,
                        "gameName": gameName,
                        "imageUrl": imageUrl,
                        "fullname": user.fullname,
                        "timestamp": Timestamp(date: Date()),
                        "username": user.username,
                        "profileImageUrl": user.profileImageUrl,
                        "status": 0,
                        "likes": 0,
                        "answers": 0,
                        "id": docRef.documentID
                    ]
                    

                    docRef.setData(data) { _ in
                        
                        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
                        let userTweetsRef = COLLECTION_USERS.document(uid).collection("user-questions")
                        userTweetsRef.document(docRef.documentID).setData([:]) { _ in
                            self.isPresented = false
                            self.loadingNow = false
                            self.questionUploaded = true
                        }
                            
                    }
                        
                }
            }
        }

    }
}
