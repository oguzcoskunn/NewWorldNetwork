//
//  TweetActionsView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 25.08.2021.
//

import SwiftUI

struct TweetActionsView: View {
    let tweet: Tweet
    @ObservedObject var viewModel: TweeetActionViewModel
    @ObservedObject var replyViewModel: ReplyViewModel
    @State var isShowingNewCommentView = false
    @State var replyUploaded = false
    @Binding var tweetUploaded: Bool
    
    @State var user: User
    @State var showRepliesView = false
    @State var showLikesView = false
    @State var showProfile = false
    @State var selectedFilterComment: TweetStatsFilterOptions = .comments
    @State var selectedFilterLike: TweetStatsFilterOptions = .likes
    
    init(tweet: Tweet, user: User, tweetUploaded: Binding<Bool>, viewModel: TweeetActionViewModel, replyViewModel: ReplyViewModel){
        self.tweet = tweet
        self.viewModel = viewModel
        self.replyViewModel = replyViewModel
        self._tweetUploaded = tweetUploaded
        self.user = user
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let user = user {
                NavigationLink(
                    destination: LazyView(UserProfileView(user: user, isActive: $showProfile)),
                    isActive: $showProfile,
                    label: {})
            }
            HStack(spacing: 50) {
                HStack {
                    Button(action: {
                        isShowingNewCommentView.toggle()
                    }, label: {
                        Image(systemName: "bubble.left")
                            .font(.system(size: 16))
                            .frame(width: 32, height: 32)
                    }).fullScreenCover(isPresented: $isShowingNewCommentView) {
                        NewCommentView(tweet: tweet, isPresented: $isShowingNewCommentView, replyUploaded: $replyUploaded)
                    }
                    Button(action: {
                        showRepliesView.toggle()
                    }, label: {
                        Text("\(replyViewModel.replies.count)")
                    }).sheet(isPresented: $showRepliesView) {
                        TweetStatsView(tweet: tweet, showRepliesView: $showRepliesView, showLikesView: $showLikesView, showProfile: $showProfile, user: $user, selectedFilter: $selectedFilterComment)
                            .onDisappear {
                                selectedFilterComment = .comments
                            }
                    }
                }
                HStack {
                    Button(action: {
                        updateLikeCount()
                    }, label: {
                        Image(systemName: viewModel.didLike ? "heart.fill" : "heart")
                            .font(.system(size: 16))
                            .frame(width: 32, height: 32)
                            .foregroundColor(viewModel.didLike ? Color("NWorange") : Color("NWgray"))
                    })
                    Button(action: {
                        showLikesView.toggle()
                    }, label: {
                        Text("\(viewModel.likeCount)")
                    }).sheet(isPresented: $showLikesView) {
                        TweetStatsView(tweet: tweet, showRepliesView: $showRepliesView, showLikesView: $showLikesView, showProfile: $showProfile, user: $user, selectedFilter: $selectedFilterLike)
                            .onDisappear {
                                selectedFilterLike = .likes
                            }
                    }
                    
                }
                
                Spacer()
                //            Button(action: {}, label: {
                //                Image(systemName: "arrow.2.squarepath")
                //                    .font(.system(size: 16))
                //                    .frame(width: 32, height: 32)
                //            })
                //            Spacer()
                //            Button(action: {}, label: {
                //                Image(systemName: "bookmark")
                //                    .font(.system(size: 16))
                //                    .frame(width: 32, height: 32)
                //            })
            }
            .onChange(of: replyUploaded) { value in
                if value == true {
                    DispatchQueue.main.async() {
                        self.replyViewModel.fetchTweetReplies(tweetID: tweet.id)
                    }
                    replyUploaded = false
                    
                }
                
            }
            .buttonStyle(FlatLinkStyle())
            .foregroundColor(Color("NWgray"))
        }
    }
    
    @State var dataSent = false
    
    func updateLikeCount() {
        let currentDidLike = viewModel.didLike
        if viewModel.didLike {
            viewModel.likeCount -= 1
        } else {
            viewModel.likeCount += 1
        }
        viewModel.didLike.toggle()
        
        if dataSent == false {
            dataSent = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                if currentDidLike != viewModel.didLike {
                    viewModel.didLike ? viewModel.likeTweet() : viewModel.unlikeTweet()
                }
                    dataSent = false
            }
        }
            
    }
}

