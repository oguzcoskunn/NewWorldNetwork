//
//  TweetActionViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 25.08.2021.
//

import SwiftUI
import Firebase
import OneSignal

class TweeetActionViewModel: ObservableObject {
    let tweet: Tweet
    let user : User
    @Published var didLike = false
    @Published var likeCount = 0
    @Published var replyCount = 0
    
    init(tweet: Tweet, user: User) {
        self.tweet = tweet
        self.user = user
        checkIfUserLikedTweet()
        getTweetLikeReplyCounts()
    }
    
    func likeTweet() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        let tweetLikesRef = COLLECTION_TWEETS.document(tweet.id).collection("tweet-likes")
        let userLikesRef = COLLECTION_USERS.document(uid).collection("user-likes")
        
        COLLECTION_TWEETS.document(tweet.id).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            guard let likeCount = data["likes"] as? Int else { return }
            
            COLLECTION_TWEETS.document(self.tweet.id).updateData(["likes": likeCount + 1]) { _ in
                tweetLikesRef.document(uid).setData([:]) { _ in
                    userLikesRef.document(self.tweet.id).setData([:]) { _ in
                        //self.didLike = true
                    }
                }
            }
            
        }
        
        if let currentUser = AuthViewModel.shared.user {
            if currentUser.id != self.tweet.uid {
                let userNotifRef = COLLECTION_USERS.document(self.tweet.uid).collection("user-notifications").document("like-\(self.tweet.id)")
                
                userNotifRef.getDocument { snapshot, _ in
                    guard let userGotThisNotif = snapshot?.exists else { return }
                    if userGotThisNotif {
                        guard let data = snapshot?.data() else { return }
                        guard let senderUid = data["senderUid"] as? String else { return }
                        if senderUid != currentUser.id {
                            let notificationRef = COLLECTION_USERS.document(self.tweet.uid).collection("user-notifications").document("like-\(self.tweet.id)")
                            
                            let notificationData: [String: Any] = [
                                "isRead": 0,
                                "notifyType": "like",
                                "tweetID": self.tweet.id,
                                "id": self.tweet.id,
                                "senderUsername": currentUser.username,
                                "timestamp": Timestamp(date: Date()),
                                "senderFullname": currentUser.fullname,
                                "senderUid": currentUser.id,
                                "senderCaption": self.tweet.caption,
                                "senderProfileImageUrl": currentUser.profileImageUrl,
                                "senderImageUrl": self.tweet.imageUrl,
                            ]
                            notificationRef.setData(notificationData) { _ in
                                OneSignal.postNotification(["contents": ["en": "\(currentUser.fullname) liked your post"], "include_player_ids": [self.user.playerId]])
                            }
                        }
                    } else {
                        let notificationRef = COLLECTION_USERS.document(self.tweet.uid).collection("user-notifications").document("like-\(self.tweet.id)")
                        
                        let notificationData: [String: Any] = [
                            "isRead": 0,
                            "notifyType": "like",
                            "tweetID": self.tweet.id,
                            "id": self.tweet.id,
                            "senderUsername": currentUser.username,
                            "timestamp": Timestamp(date: Date()),
                            "senderFullname": currentUser.fullname,
                            "senderUid": currentUser.id,
                            "senderCaption": self.tweet.caption,
                            "senderProfileImageUrl": currentUser.profileImageUrl,
                            "senderImageUrl": self.tweet.imageUrl,
                        ]
                        notificationRef.setData(notificationData) { _ in
                            OneSignal.postNotification(["contents": ["en": "\(currentUser.fullname) liked your post"], "include_player_ids": [self.user.playerId]])
                        }
                        
                    }
                }
            }
        }
    }
    
    func unlikeTweet() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        let tweetLikesRef = COLLECTION_TWEETS.document(tweet.id).collection("tweet-likes")
        let userLikesRef = COLLECTION_USERS.document(uid).collection("user-likes")
        
        COLLECTION_TWEETS.document(tweet.id).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            guard let likeCount = data["likes"] as? Int else { return }
            
            COLLECTION_TWEETS.document(self.tweet.id).updateData(["likes": likeCount - 1]) { _ in
                tweetLikesRef.document(uid).delete { _ in
                    userLikesRef.document(self.tweet.id).delete { _ in
                        //self.didLike = false
                    }
                }
            }
            
        }
    }
    
//    func replyTweet() {
//        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
//        let tweetLikesRef = COLLECTION_TWEETS.document(tweet.id).collection("tweet-replies")
//        let userLikesRef = COLLECTION_USERS.document(uid).collection("user-replies")
//
//        COLLECTION_TWEETS.document(self.tweet.id).updateData(["likes": 1]) { _ in
//            tweetLikesRef.document(uid).setData([:]) { _ in
//                userLikesRef.document(self.tweet.id).setData([:]) { _ in
//                    //self.didLike = true
//                }
//            }
//        }
//    }
    
    func checkIfUserLikedTweet() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        let userLikesRef = COLLECTION_USERS.document(uid).collection("user-likes").document(tweet.id)
        
        userLikesRef.getDocument { snapshot, _ in
            guard let didLike = snapshot?.exists else { return }
            self.didLike = didLike
        }
    }
    
    func getTweetLikeReplyCounts() {
        COLLECTION_TWEETS.document(tweet.id).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            guard let likeCount = data["likes"] as? Int else { return }
            guard let replyCount = data["replies"] as? Int else { return }
            self.likeCount = likeCount
            self.replyCount = replyCount
            
        }
    }
}
