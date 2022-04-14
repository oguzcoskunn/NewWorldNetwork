//
//  TweetOptionsViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 24.09.2021.
//

import SwiftUI
import Firebase

class TweetOptionsViewModel: ObservableObject {
    @Binding var tweetUploaded: Bool
    
    init(tweetUploaded: Binding<Bool>) {
        self._tweetUploaded = tweetUploaded
    }
    
    func deleteTweet(tweet: Tweet) {
        let tweetRef = COLLECTION_TWEETS.document(tweet.id)
        let tweetLikesRef = COLLECTION_TWEETS.document(tweet.id).collection("tweet-likes")
        let tweetRepliesRef = COLLECTION_TWEETS.document(tweet.id).collection("tweet-replies")
        let userTweetsRef = COLLECTION_USERS.document(tweet.uid).collection("user-tweets").document(tweet.id)
        let userNotificationsLikeRef = COLLECTION_USERS.document(tweet.uid).collection("user-notifications").document("like-\(tweet.id)")
        let userNotificationsReplyRef = COLLECTION_USERS.document(tweet.uid).collection("user-notifications").document("reply-\(tweet.id)")

        userTweetsRef.delete() { _ in
            userNotificationsLikeRef.delete() { _ in
                userNotificationsReplyRef.delete() { _ in
                    tweetRef.delete() { _ in
                        
                        tweetLikesRef.getDocuments { snapshot, _ in
                            guard let likeDocuments = snapshot?.documents else { return }
                            likeDocuments.forEach { document in
                                tweetLikesRef.document(document.documentID).delete() { _ in
                                    
                                }
                            }
                        }
                        
                        tweetRepliesRef.getDocuments { snapshot, _ in
                            guard let documents = snapshot?.documents else { return }
                            documents.forEach { document in
                                COLLECTION_TWEETS.document(tweet.id).collection("tweet-replies").document(document.documentID).collection("user-replies").getDocuments { snapshot, _ in
                                    guard let replyDocuments = snapshot?.documents else { return }
                                    replyDocuments.forEach { reply in
                                        COLLECTION_TWEETS.document(tweet.id).collection("tweet-replies").document(document.documentID).collection("user-replies").document(reply.documentID).delete() { _ in
                                            COLLECTION_TWEETS.document(tweet.id).collection("tweet-replies").document(document.documentID).delete() { _ in
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        COLLECTION_USERS.getDocuments { snapshot, _ in
                            guard let usersDocuments = snapshot?.documents else { return }
                            usersDocuments.forEach { document in
                                COLLECTION_USERS.document(document.documentID).collection("user-likes").document(tweet.id).delete() { _ in
                                    
                                }
                            }
                        }
                        
                        self.tweetUploaded = true
                    }
                }
            }
        }
    }
}
