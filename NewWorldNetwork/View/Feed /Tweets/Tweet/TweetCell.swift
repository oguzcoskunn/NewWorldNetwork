//
//  TweetCell.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 14.08.2021.
//

import SwiftUI
import ToastSwiftUI

struct TweetCell: View {
    @State var reportToast: Bool = false
    @State var reportandBlockToast: Bool = false
    let tweet: Tweet
    let user: User
    @ObservedObject var viewModel: TweeetActionViewModel
    @ObservedObject var replyViewModel: ReplyViewModel
    @Binding var tweetUploaded: Bool
    @State private var isPresented = false
    
    init(tweet: Tweet, user: User, tweetUploaded: Binding<Bool>, viewModel: TweeetActionViewModel, replyViewModel: ReplyViewModel) {
        self.tweet = tweet
        self.user = user
        self._tweetUploaded = tweetUploaded
        self.viewModel = viewModel
        self.replyViewModel = replyViewModel
    }
    
    var body: some View {   
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(user.fullname)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Text("@\(user.username) .")
                    .foregroundColor(Color("NWgray"))
                Text(tweet.timestampString)
                    .foregroundColor(Color("NWgray"))
                Spacer()
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color("NWgray"))
                        .rotationEffect(.degrees(-90))
                }
                .sheet(isPresented: $isPresented, content: {
                    TweetOptions(tweet: tweet, tweetUploaded: $tweetUploaded, reportToast: $reportToast, reportandBlockToast: $reportandBlockToast, isPresented: $isPresented)
                        .background(Color("NWtoolbar"))
                        .edgesIgnoringSafeArea(.all)
                })
                
            }
            
            if !tweet.caption.isEmpty {
                Text(tweet.caption)
                    .foregroundColor(.white)
            }
           
            if !tweet.imageUrl.isEmpty {
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
            }
            
            
            TweetActionsView(tweet: tweet, user: user, tweetUploaded: $tweetUploaded, viewModel: viewModel, replyViewModel: replyViewModel)
                .padding(.top, 5)
                .padding(.leading, -5)
            
        }
        .toast(isPresenting: $reportToast, message: "User reported!", icon: .success, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
        .toast(isPresenting: $reportandBlockToast, message: "User blocked and reported!", icon: .success, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
        .onChange(of: reportandBlockToast) { newValue in
            if !newValue {
                AuthViewModel.shared.getBlockedUsers()
                self.tweetUploaded.toggle()
            }
        }
    }
}


