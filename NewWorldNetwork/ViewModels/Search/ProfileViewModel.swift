//
//  ProfileViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 25.08.2021.
//

import SwiftUI
import Firebase
import UIKit
import OneSignal

class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var userTweets = [Tweet]()
    @Published var likedTweets = [Tweet]()
    
    init(user: User) {
        self.user = user
        checkIfUserIsFollowed()
        fetchUserTweets()
        fetchLikedTweets()
        fetchUserStats()
    }
    
    func tweets(forFilter filter: TweetFilterOptions) -> [Tweet] {
        switch filter {
        case .tweets: return userTweets
        case .likes: return likedTweets
        }
    }
}

/// MARK: - API

extension ProfileViewModel {
    func follow() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let followingRef = COLLECTION_FOLLOWING.document(currentUid).collection("user-following")
        let followersRef = COLLECTION_FOLLOWERS.document(user.id).collection("user-followers")
        
        followingRef.document(user.id).setData([:]) { _ in
            followersRef.document(currentUid).setData([:]) { _ in
                self.user.isFollowed = true
            }
        }
        
        
        if let currentUser = AuthViewModel.shared.user {
            let userNotifRef = COLLECTION_USERS.document(user.id).collection("user-notifications").document("follow-\(currentUid)")
            
            userNotifRef.getDocument { snapshot, _ in
                guard let userGotThisNotif = snapshot?.exists else { return }
                if userGotThisNotif {
                    guard let data = snapshot?.data() else { return }
                    guard let senderUid = data["senderUid"] as? String else { return }
                    if senderUid != currentUser.id {
                        let notificationData: [String: Any] = [
                            "id": userNotifRef.documentID,
                            "isRead": 0,
                            "notifyType": "follow",
                            "senderUsername": currentUser.username,
                            "senderUid": currentUser.id,
                            "timestamp": Timestamp(date: Date()),
                            "senderFullname": currentUser.fullname,
                            "senderProfileImageUrl": currentUser.profileImageUrl
                        ]
                        
                        userNotifRef.setData(notificationData) { _ in
                            OneSignal.postNotification(["contents": ["en": "\(currentUser.fullname) folllowed you!"], "include_player_ids": [self.user.playerId]])
                        }
                    }
                } else {
                    let notificationData: [String: Any] = [
                        "id": userNotifRef.documentID,
                        "isRead": 0,
                        "notifyType": "follow",
                        "senderUsername": currentUser.username,
                        "senderUid": currentUser.id,
                        "timestamp": Timestamp(date: Date()),
                        "senderFullname": currentUser.fullname,
                        "senderProfileImageUrl": currentUser.profileImageUrl
                    ]
                    
                    userNotifRef.setData(notificationData) { _ in
                        OneSignal.postNotification(["contents": ["en": "\(currentUser.fullname) folllowed you!"], "include_player_ids": [self.user.playerId]])
                    }
                }
            }
        }
        
    }
    
    func unfollow() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let followingRef = COLLECTION_FOLLOWING.document(currentUid).collection("user-following")
        let followersRef = COLLECTION_FOLLOWERS.document(user.id).collection("user-followers")
        
        followingRef.document(user.id).delete { _ in
            followersRef.document(currentUid).delete { _ in
                self.user.isFollowed = false
            }
        }
    }
    
    func checkIfUserIsFollowed() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard !user.isCurrentUser else { return }
        let followingRef = COLLECTION_FOLLOWING.document(currentUid).collection("user-following")
        
        followingRef.document(user.id).getDocument { snapshot, _ in
            guard let isFollowed = snapshot?.exists else { return }
            self.user.isFollowed = isFollowed
        }
    }
    
    func fetchUserTweets() {
        COLLECTION_TWEETS.whereField("uid", isEqualTo: user.id).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.userTweets = documents.map({ Tweet(dictionary: $0.data()) })
            self.userTweets.sort(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
        }
    }
    
    func fetchLikedTweets() {
        var tweets = [Tweet]()
        
        COLLECTION_USERS.document(user.id).collection("user-likes").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let tweetIDs = documents.map({ $0.documentID })
            
            tweetIDs.forEach { id in
                COLLECTION_TWEETS.document(id).getDocument { snapshot, _ in
                    guard let data = snapshot?.data() else { return }
                    let tweet = Tweet(dictionary: data)
                    tweets.append(tweet)
                    guard tweets.count == tweetIDs.count else { return }
                    
                    self.likedTweets = tweets
                    self.likedTweets.sort(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
                }
            }
        }
    }
    
    func fetchUserStats() {
        let followersRef = COLLECTION_FOLLOWERS.document(user.id).collection("user-followers")
        let followingRef = COLLECTION_FOLLOWING.document(user.id).collection("user-following")
        
        followersRef.getDocuments { snapshot, _ in
            guard let followerCount = snapshot?.documents.count else { return }
            
            followingRef.getDocuments { snapshot, _ in
                guard let followingCount = snapshot?.documents.count else { return }
                
                self.user.stats = UserStats(followers: followerCount, following: followingCount)
            }
        }
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            self.user = User(dictionary: data)
        }
    }
    
}
