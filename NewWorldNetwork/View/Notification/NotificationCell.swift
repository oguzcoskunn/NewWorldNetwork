//
//  ReplyCell.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 22.09.2021.
//

import SwiftUI

struct NotificationCell: View {
    @State var isProfileViewActive: Bool = false
    let notifInfo: Notification
    @ObservedObject var feedViewModel = FeedViewModel()
    @ObservedObject var questionViewModel = QuestionAnswerViewModel()
    @State var tweetUploaded = false
    
    var body: some View {
        if !AuthViewModel.shared.checkUidForBlock(userUid: notifInfo.senderUid) {
            if (notifInfo.notifyType == "reply") {
                ForEach(feedViewModel.tweets) { tweet in
                    if (tweet.id == notifInfo.tweetID) {
                        ForEach(feedViewModel.users) { user in
                            let userInfo = user
                            if userInfo.id == tweet.uid {
                                NavigationLink(
                                    destination: TweetDetailView(tweet: tweet, user: user, tweetUploaded: $tweetUploaded, viewModel: TweeetActionViewModel(tweet: tweet, user: user), replyViewModel: ReplyViewModel(tweetID: tweet.id)),
                                    label: {
                                        NotificationContent(notification: notifInfo, likeCount: 0, replyCount: tweet.replies-1, answerCount: 0)
                                    })
                                Divider()
                            }
                        }
                    }
                }
            } else if (notifInfo.notifyType == "answer") {
                    ForEach(questionViewModel.questions) { question in
                        if (question.id == notifInfo.tweetID) {
                            ForEach(feedViewModel.users) { user in
                                let userInfo = user
                                if userInfo.id == question.uid {
                                    NavigationLink(
                                        destination:
                                            QuestionDetailView(question: question, user: user),
                                        label: {
                                            NotificationContent(notification: notifInfo, likeCount: 0, replyCount: 0, answerCount: question.answers-1)
                                        })
                                    Divider()
                                }
                            }
                        }
                    }
            } else if (notifInfo.notifyType == "follow") {
                ForEach(feedViewModel.users) { user in
                    if notifInfo.senderUsername == user.username {
                        NavigationLink(
                            destination: UserProfileView(user: user, isActive: $isProfileViewActive),
                            isActive: $isProfileViewActive,
                            label: {
                                NotificationContent(notification: notifInfo, likeCount: 0, replyCount: 0, answerCount: 0)
                            })
                        Divider()
                    }
                }
            } else if (notifInfo.notifyType == "like") {
                ForEach(feedViewModel.tweets) { tweet in
                    if (tweet.id == notifInfo.tweetID) {
                        ForEach(feedViewModel.users) { user in
                            if user.id == tweet.uid {
                                NavigationLink(
                                    destination: TweetDetailView(tweet: tweet, user: user, tweetUploaded: $tweetUploaded, viewModel: TweeetActionViewModel(tweet: tweet, user: user), replyViewModel: ReplyViewModel(tweetID: tweet.id)),
                                    label: {
                                        NotificationContent(notification: notifInfo, likeCount: tweet.likes-1, replyCount: 0, answerCount: 0)
                                    })
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }
}
