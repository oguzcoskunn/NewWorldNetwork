//
//  TweetStatsViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 25.09.2021.
//


import SwiftUI
import Firebase

class TweetStatsViewModel: ObservableObject {
    let tweet: Tweet
    @Published var tweetComments = [User]()
    @Published var tweetLikes = [User]()
    
    init(tweet: Tweet) {
        self.tweet = tweet
        getTweetLikedUsers()
        getTweetRepliedUsers()
    }
    
    func stats(forFilter filter: TweetStatsFilterOptions) -> [User] {
        switch filter {
        case .comments: return tweetComments
        case .likes: return tweetLikes
        }
    }
}

/// MARK: - API

extension TweetStatsViewModel {
    func getTweetLikedUsers() {
        if !self.tweetLikes.isEmpty {
            self.tweetLikes.removeAll()
        }
        COLLECTION_TWEETS.document(tweet.id).collection("tweet-likes").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            documents.forEach { document in
                COLLECTION_USERS.document(document.documentID).getDocument { document, _ in
                    guard let data = document?.data() else { return }
                    self.tweetLikes.append(User(dictionary: data))
                }
                
            }
        }
    }
    
    func getTweetRepliedUsers() {
        if !self.tweetComments.isEmpty {
            self.tweetComments.removeAll()
        }
        COLLECTION_TWEETS.document(tweet.id).collection("tweet-replies").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            documents.forEach { document in
                COLLECTION_USERS.document(document.documentID).getDocument { document, _ in
                    guard let data = document?.data() else { return }
                    self.tweetComments.append(User(dictionary: data))
                }
                
            }
        }
    }
}

