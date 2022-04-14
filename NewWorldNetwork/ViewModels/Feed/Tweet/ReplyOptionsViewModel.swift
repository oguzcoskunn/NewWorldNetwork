//
//  ReplyOptionsViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 2.10.2021.
//

import SwiftUI
import Firebase

class ReplyOptionsViewModel: ObservableObject {
    @Published var replyDeleted: Bool = false
    
    func deleteReply(reply: Reply, tweetId: String) {
        COLLECTION_TWEETS.document(tweetId).collection("tweet-replies").document(reply.uid).collection("user-replies").document(reply.id).delete() { _ in
            COLLECTION_TWEETS.document(tweetId).collection("tweet-replies").document(reply.uid).collection("user-replies").getDocuments { snapshot, _ in
                guard let replyDocuments = snapshot?.documents else { return }
                if replyDocuments.count > 0 {
                    self.replyDeleted = true
                } else {
                    COLLECTION_TWEETS.document(tweetId).collection("tweet-replies").document(reply.uid).delete() { _ in
                        self.replyDeleted = true
                    }
                }
            }
            
        }
    }
}
