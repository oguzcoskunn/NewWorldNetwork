//
//  TweetOptions.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 24.09.2021.
//

import SwiftUI

struct TweetOptions: View {
    @State private var showBlockAlert: Bool = false
    let tweet: Tweet
    @Binding var tweetUploaded: Bool
    @Binding var isPresented: Bool
    @Binding var reportToast: Bool
    @Binding var reportandBlockToast: Bool
    @ObservedObject var viewModel: TweetOptionsViewModel
    @ObservedObject var reportViewModel = ReportViewModel()
    
    init(tweet: Tweet, tweetUploaded: Binding<Bool>, reportToast: Binding<Bool>, reportandBlockToast: Binding<Bool>, isPresented: Binding<Bool>) {
        self.tweet = tweet
        self._tweetUploaded = tweetUploaded
        self._reportToast = reportToast
        self._isPresented = isPresented
        self._reportandBlockToast = reportandBlockToast
        self.viewModel = TweetOptionsViewModel(tweetUploaded: tweetUploaded)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            if AuthViewModel.shared.userSession?.uid != tweet.uid {
                HStack {
                    Button {
                        showBlockAlert.toggle()
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "flag.fill")
                            Text("Report the User")
                        }
                        .font(.system(size: 18))
                    }
                    Spacer()
                }
                .alert(isPresented:$showBlockAlert) {
                            Alert(
                                title: Text("Do you also want to block this user?"),
                                message: Text("If you block this user you will not be able to see their content."),
                                primaryButton: .destructive(Text("Report & Block User")) {
                                    reportViewModel.reportTheContentandBlockUser(contentID: self.tweet.id, contentOwner: self.tweet.uid, type: "tweet")
                                    self.reportandBlockToast.toggle()
                                    isPresented.toggle()
                                },
                                secondaryButton: .cancel(Text("Report User")) {
                                    reportViewModel.reportTheContent(contentID: self.tweet.id, contentOwner: self.tweet.uid, type: "tweet")
                                    self.reportToast.toggle()
                                    isPresented.toggle()
                                }
                            )
                        }
            }
            
            if AuthViewModel.shared.userSession?.uid == tweet.uid {
                HStack {
                    Button {
                        viewModel.deleteTweet(tweet: tweet)
                        isPresented.toggle()
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "multiply.circle")
                            Text("Delete the Post")
                        }
                        .font(.system(size: 18))
                    }
                    Spacer()
                }
                
            }
            
            Spacer()
        }
            .foregroundColor(.white)
        .padding(.vertical, 5)
        .padding(.horizontal, 25)
        .padding(.top, 40)
    }
}
