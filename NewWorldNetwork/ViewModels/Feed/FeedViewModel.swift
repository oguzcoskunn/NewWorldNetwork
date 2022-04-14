//
//  FeedeViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 25.08.2021.
//

import SwiftUI

class FeedViewModel: ObservableObject {
    @Published var tweets = [Tweet]()
    @Published var users = [User]()
    @Published var loadingNow: Bool = false
    
    init() {
        fetchTweets(onlyFollowing: false)
        fetchUsers()
    }
    
    func fetchTweets(onlyFollowing: Bool) {
        COLLECTION_TWEETS.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            if onlyFollowing {
                guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
                COLLECTION_FOLLOWING.document(currentUid).collection("user-following").getDocuments { snapshot, _ in
                    guard let followingDocuments = snapshot?.documents else { return }
                    var followingUsers = followingDocuments.map({ $0.documentID })
                    followingUsers.append(currentUid)
                    if self.tweets.count > 0 {
                        self.tweets.removeAll()
                    }
                    self.loadingNow = false
                    followingUsers.forEach { followingUserUid in
                        documents.forEach { tw in
                            guard let tweetUid = tw.data()["uid"] as? String else { return }
                            if tweetUid == followingUserUid {
                                self.tweets.append(Tweet(dictionary: tw.data()))
                                self.tweets.sort(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
                            }
                        }
                    }
                }
            } else {
                self.tweets = documents.map({ Tweet(dictionary: $0.data()) })
                self.tweets.sort(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
                self.loadingNow = false
            }
            
        }
    }
    
    func fetchUsers() {
        COLLECTION_USERS.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let users = documents.map({ User(dictionary: $0.data()) })
            self.users = users
        }
    }

}
