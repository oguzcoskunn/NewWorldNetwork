//
//  TweetDetailView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 25.08.2021.
//

import SwiftUI

struct TweetDetailView: View {
    @State var isProfileViewActive: Bool = false
    let tweet: Tweet
    let user: User
    @Binding var tweetUploaded: Bool
    @ObservedObject var tweetActionViewModel: TweeetActionViewModel
    @ObservedObject var viewModel: ReplyViewModel
    @ObservedObject var searchViewModel = SearchViewModel(config: .search)
    
    init(tweet: Tweet, user: User, tweetUploaded: Binding<Bool>, viewModel: TweeetActionViewModel, replyViewModel: ReplyViewModel){
        self.tweet = tweet
        self.user = user
        self.tweetActionViewModel = viewModel
        self._tweetUploaded = tweetUploaded
        self.viewModel = replyViewModel
        //self.viewModel.fetchTweetReplies(tweetID: tweet.id)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading) {
                    NavigationLink(
                        destination: UserProfileView(user: user, isActive: $isProfileViewActive),
                        isActive: $isProfileViewActive,
                        label: {
                            HStack {
                                AsyncImage(
                                    url: URL(string: user.profileImageUrl)!,
                                    placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                    image: { Image(uiImage: $0).resizable()}
                                )
                                    .scaledToFill()
                                    .clipped()
                                    .frame(width: 56, height: 56)
                                    .cornerRadius(28)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.fullname)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Text("@\(user.username)")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color("NWgray"))
                                }
                            }
                        }).buttonStyle(FlatLinkStyle())
                    
                    if !tweet.caption.isEmpty {
                        Text(tweet.caption)
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                    }
                    
                    if !tweet.imageUrl.isEmpty {
                        HStack {
                            NavigationLink(
                                destination: ImageFullScreenView(imageUrl: tweet.imageUrl),
                                label: {
                                    AsyncImage(
                                        url: URL(string: tweet.imageUrl)!,
                                        placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                        image: { Image(uiImage: $0).resizable()}
                                    )
                                        .scaledToFit()
                                        .clipped()
                                        .cornerRadius(20)
                                        .padding(.top, 5)
                                        .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
                                }).buttonStyle(FlatLinkStyle())
                            Spacer()
                        }
                    }

                    Text(tweet.detailedTimestampString)
                        .font(.system(size: 14))
                        .foregroundColor(Color("NWgray"))
                        .padding(.top, 5)
                }
                
                Divider()
                
                TweetActionsView(tweet: tweet, user: user, tweetUploaded: $tweetUploaded, viewModel: tweetActionViewModel, replyViewModel: viewModel)
                Divider()
                ForEach(viewModel.replies) { reply in
                    ForEach(searchViewModel.users) { user in
                        if user.id == reply.uid {
                            LazyVStack(alignment: .leading) {
                                ReplyBlockView(user: user, reply: reply, tweetID: self.tweet.id, replyViewModel: viewModel)
                                Divider()
                            }
                        }
                    }
                }
                .padding(.vertical, 3)
                
                
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.top, 100)
            
        }
        .onChange(of: self.viewModel.refreshReplies, perform: { newValue in
            if newValue {
                self.viewModel.fetchTweetReplies(tweetID: self.tweet.id)
                self.viewModel.refreshReplies = false
            }
        })
        .padding(.horizontal, 1)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("")
        .background(Color("NWbackground").scaledToFill())
        .edgesIgnoringSafeArea(.all)
        
    }
}
