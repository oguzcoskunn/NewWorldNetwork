//
//  ReplyViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 8.09.2021.
//


import SwiftUI

class ReplyViewModel: ObservableObject {
    let tweetID: String
    @Published var replies = [Reply]()
    @Published var refreshReplies: Bool = false
    
    init(tweetID: String) {
        self.tweetID = tweetID
        fetchTweetReplies(tweetID: tweetID)
    }
    
    
    func fetchTweetReplies(tweetID: String) {
        if !self.replies.isEmpty {
            self.replies.removeAll()
        }
        COLLECTION_TWEETS.document(tweetID).collection("tweet-replies").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            documents.forEach { document in
                COLLECTION_TWEETS.document(tweetID).collection("tweet-replies").document(document.documentID).collection("user-replies").getDocuments { snapshot, _ in
                    guard let replyDocuments = snapshot?.documents else { return }
                    replyDocuments.forEach { reply in
                        self.replies.append(Reply(dictionary: reply.data()))
                        self.replies.sort(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
                    }
                }
            }
        }
    }
    
}
