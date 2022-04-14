//
//  testModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 5.09.2021.
//

import SwiftUI

struct TweetBlockView: View {
    @State var isProfileViewActive: Bool = false
    let tweet: Tweet
    let user: User
    @ObservedObject var viewModel: TweeetActionViewModel
    @ObservedObject var replyViewModel: ReplyViewModel
    @Binding var tweetUploaded: Bool
    
    init(tweet: Tweet, user: User, tweetUploaded: Binding<Bool>) {
        self.tweet = tweet
        self.user = user
        self._tweetUploaded = tweetUploaded
        self.viewModel = TweeetActionViewModel(tweet: tweet, user: user)
        self.replyViewModel = ReplyViewModel(tweetID: tweet.id)
    }
    
    var body: some View {
        if !AuthViewModel.shared.checkUidForBlock(userUid: self.tweet.uid) {
            HStack(alignment: .top, spacing: 12) {
                NavigationLink(
                    destination:
                        LazyView(UserProfileView(user: user, isActive: $isProfileViewActive))
                    ,
                    isActive: $isProfileViewActive,
                    label: {
                        AsyncImage(
                           url: URL(string: user.profileImageUrl)!,
                           placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                           image: { Image(uiImage: $0).resizable()}
                        )
                            .scaledToFill()
                            .clipped()
                            .frame(width: 56, height: 56)
                            .cornerRadius(56 / 2)
                            .padding(.leading)
                    }).buttonStyle(FlatLinkStyle())
                NavigationLink(
                    destination: LazyView(TweetDetailView(tweet: tweet, user: user, tweetUploaded: $tweetUploaded, viewModel: viewModel, replyViewModel: replyViewModel)),
                    label: {
                        TweetCell(tweet: tweet, user: user, tweetUploaded: $tweetUploaded, viewModel: viewModel, replyViewModel: replyViewModel)
                    }).buttonStyle(FlatLinkStyle())
            }
            .padding(.bottom, 1)
        }
    }
}


