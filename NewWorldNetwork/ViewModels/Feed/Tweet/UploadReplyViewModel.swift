//
//  UploadTweetViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 25.08.2021.
//

import SwiftUI
import Firebase
import OneSignal

class UploadReplyViewModel: ObservableObject {
    @Binding var isPresented: Bool
    @Binding var replyUploaded: Bool
    @Published var loadingNow: Bool = false
    let tweet: Tweet
    
    init(tweet: Tweet, isPresented: Binding<Bool>, replyUploaded: Binding<Bool>) {
        self.tweet = tweet
        self._isPresented = isPresented
        self._replyUploaded = replyUploaded
    }
    
    func replyTweet(caption: String) {
        guard let user = AuthViewModel.shared.user else { return }
        let docRef = COLLECTION_TWEETS.document(self.tweet.id).collection("tweet-replies").document(user.id).collection("user-replies").document()
        
        
        let data: [String: Any] = [
            "uid": user.id,
            "caption": caption,
            "fullname": user.fullname,
            "timestamp": Timestamp(date: Date()),
            "username": user.username,
            "profileImageUrl": user.profileImageUrl,
            "likes": 0,
            "id": docRef.documentID
        ]
        

        
        COLLECTION_TWEETS.document(self.tweet.id).collection("tweet-replies").document(user.id).setData([:]) { _ in
            COLLECTION_TWEETS.document(self.tweet.id).collection("tweet-replies").document(user.id).collection("user-replies").document(docRef.documentID).setData(data) { _ in
                self.isPresented = false
                self.loadingNow = false
                self.replyUploaded = true
            }
        }
        
        
        let repliesRef = COLLECTION_TWEETS.document(self.tweet.id)
        
        repliesRef.getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            guard let repliesCount = data["replies"] as? Int else { return }
            
            repliesRef.updateData(["replies": repliesCount + 1]) { _ in
                
            }
            
        }
        
        if user.id != self.tweet.uid {
            let userNotifRef = COLLECTION_USERS.document(self.tweet.uid).collection("user-notifications").document("reply-\(self.tweet.id)")
            
            userNotifRef.getDocument { snapshot, _ in
                guard let userGotThisNotif = snapshot?.exists else { return }
                if userGotThisNotif {
                    guard let data = snapshot?.data() else { return }
                    guard let senderUid = data["senderUid"] as? String else { return }
                    if senderUid != user.id {
                        let notificationRef = COLLECTION_USERS.document(self.tweet.uid).collection("user-notifications").document("reply-\(self.tweet.id)")
                        
                        let notificationData: [String: Any] = [
                            "isRead": 0,
                            "notifyType": "reply",
                            "tweetID": self.tweet.id,
                            "senderUsername": user.username,
                            "senderUid": user.id,
                            "timestamp": Timestamp(date: Date()),
                            "senderFullname": user.fullname,
                            "senderCaption": caption,
                            "senderProfileImageUrl": user.profileImageUrl,
                            "id": notificationRef.documentID
                        ]
                        
                        notificationRef.setData(notificationData) { _ in
                            COLLECTION_USERS.document(self.tweet.uid).getDocument { snapshot, _ in
                                guard let data = snapshot?.data() else { return }
                                guard let targetPlayerId = data["playerId"] as? String else { return }
                                OneSignal.postNotification(["contents": ["en": "\(user.fullname) replied your post"], "include_player_ids": [targetPlayerId]])
                            }
                        }
                    }
                } else {
                    let notificationRef = COLLECTION_USERS.document(self.tweet.uid).collection("user-notifications").document("reply-\(self.tweet.id)")
                    
                    let notificationData: [String: Any] = [
                        "isRead": 0,
                        "notifyType": "reply",
                        "tweetID": self.tweet.id,
                        "senderUsername": user.username,
                        "senderUid": user.id,
                        "timestamp": Timestamp(date: Date()),
                        "senderFullname": user.fullname,
                        "senderCaption": caption,
                        "senderProfileImageUrl": user.profileImageUrl,
                        "id": notificationRef.documentID
                    ]
                    
                    notificationRef.setData(notificationData) { _ in
                        COLLECTION_USERS.document(self.tweet.uid).getDocument { snapshot, _ in
                            guard let data = snapshot?.data() else { return }
                            guard let targetPlayerId = data["playerId"] as? String else { return }
                            OneSignal.postNotification(["contents": ["en": "\(user.fullname) replied your post"], "include_player_ids": [targetPlayerId]])
                        }
                    }
                }
            }
        }
    }
    
    
    func replyTweetwithImage(caption: String, selectedImage: UIImage) {
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
                    let docRef = COLLECTION_TWEETS.document(self.tweet.id).collection("tweet-replies").document(user.id).collection("user-replies").document()
                    
                    
                    let data: [String: Any] = [
                        "uid": user.id,
                        "caption": caption,
                        "fullname": user.fullname,
                        "timestamp": Timestamp(date: Date()),
                        "username": user.username,
                        "profileImageUrl": user.profileImageUrl,
                        "imageUrl": imageUrl,
                        "likes": 0,
                        "id": docRef.documentID
                    ]
                    
                    COLLECTION_TWEETS.document(self.tweet.id).collection("tweet-replies").document(user.id).setData([:]) { _ in
                        COLLECTION_TWEETS.document(self.tweet.id).collection("tweet-replies").document(user.id).collection("user-replies").document(docRef.documentID).setData(data) { _ in
                            self.isPresented = false
                            self.loadingNow = false
                            self.replyUploaded = true
                        }
                    }
                    
                    let repliesRef = COLLECTION_TWEETS.document(self.tweet.id)
                    
                    repliesRef.getDocument { snapshot, _ in
                        guard let data = snapshot?.data() else { return }
                        guard let repliesCount = data["replies"] as? Int else { return }
                        
                        repliesRef.updateData(["replies": repliesCount + 1]) { _ in
                            
                        }
                        
                    }
                    
                    if user.id != self.tweet.uid {
                        let userNotifRef = COLLECTION_USERS.document(self.tweet.uid).collection("user-notifications").document("reply-\(self.tweet.id)")
                        
                        userNotifRef.getDocument { snapshot, _ in
                            guard let userGotThisNotif = snapshot?.exists else { return }
                            if userGotThisNotif {
                                guard let data = snapshot?.data() else { return }
                                guard let senderUid = data["senderUid"] as? String else { return }
                                if senderUid != user.id {
                                    let notificationRef = COLLECTION_USERS.document(self.tweet.uid).collection("user-notifications").document("reply-\(self.tweet.id)")
                                    
                                    let notificationData: [String: Any] = [
                                        "isRead": 0,
                                        "notifyType": "reply",
                                        "tweetID": self.tweet.id,
                                        "senderUsername": user.username,
                                        "senderUid": user.id,
                                        "timestamp": Timestamp(date: Date()),
                                        "senderFullname": user.fullname,
                                        "senderCaption": caption,
                                        "senderProfileImageUrl": user.profileImageUrl,
                                        "senderImageUrl": imageUrl,
                                        "id": notificationRef.documentID
                                    ]
                                    
                                    notificationRef.setData(notificationData) { _ in
                                        COLLECTION_USERS.document(self.tweet.uid).getDocument { snapshot, _ in
                                            guard let data = snapshot?.data() else { return }
                                            guard let targetPlayerId = data["playerId"] as? String else { return }
                                            OneSignal.postNotification(["contents": ["en": "\(user.fullname) replied your post"], "include_player_ids": [targetPlayerId]])
                                        }
                                    }
                                }
                            } else {
                                let notificationRef = COLLECTION_USERS.document(self.tweet.uid).collection("user-notifications").document("reply-\(self.tweet.id)")
                                
                                let notificationData: [String: Any] = [
                                    "isRead": 0,
                                    "notifyType": "reply",
                                    "tweetID": self.tweet.id,
                                    "senderUsername": user.username,
                                    "senderUid": user.id,
                                    "timestamp": Timestamp(date: Date()),
                                    "senderFullname": user.fullname,
                                    "senderCaption": caption,
                                    "senderProfileImageUrl": user.profileImageUrl,
                                    "senderImageUrl": imageUrl,
                                    "id": notificationRef.documentID
                                ]
                                
                                notificationRef.setData(notificationData) { _ in
                                    COLLECTION_USERS.document(self.tweet.uid).getDocument { snapshot, _ in
                                        guard let data = snapshot?.data() else { return }
                                        guard let targetPlayerId = data["playerId"] as? String else { return }
                                        OneSignal.postNotification(["contents": ["en": "\(user.fullname) replied your post"], "include_player_ids": [targetPlayerId]])
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
                
    }
    
//    func likeTweet() {
//        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
//        let tweetLikesRef = COLLECTION_TWEETS.document(tweet.id).collection("tweet-likes")
//        let userLikesRef = COLLECTION_USERS.document(uid).collection("user-likes")
//
//        COLLECTION_TWEETS.document(tweet.id).getDocument { snapshot, _ in
//            guard let data = snapshot?.data() else { return }
//            guard let likeCount = data["likes"] as? Int else { return }
//
//            COLLECTION_TWEETS.document(self.tweet.id).updateData(["likes": likeCount + 1]) { _ in
//                tweetLikesRef.document(uid).setData([:]) { _ in
//                    userLikesRef.document(self.tweet.id).setData([:]) { _ in
//                        //self.didLike = true
//                    }
//                }
//            }
//
//        }
//    }
    
    
    
    
///    Uses completion handler to dismiss view
    
//    func uploadTweet(caption: String, completion: @escaping((Error?) -> Void)) {
//        guard let user = AuthViewModel.shared.user else { return }
//        let docRef = COLLECTION_TWEETS.document()
//
//        let data: [String: Any] = [
//            "uid": user.id,
//            "caption": caption,
//            "fullname": user.fullname,
//            "timestamp": Timestamp(date: Date()),
//            "username": user.username,
//            "profileImageUrl": user.profileImageUrl,
//            "likes": 0,
//            "id": docRef.documentID
//        ]
//
//        docRef.setData(data, completion: completion)
//    }
}
