//
//  FeedView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 14.08.2021.
//

import SwiftUI
import ToastSwiftUI

struct FeedView: View {
    @State private var refreshToast: Bool = false
    @State private var loadingToast: Bool = false
    @State private var globalIconToast: Bool = false
    @State private var globalIconDisabled: Bool = false
    @Binding var showSidebar: Bool
    
    @ObservedObject var viewModel = FeedViewModel()
    @State var onlyFollowing = false
    @Binding var newTweetUploaded: Bool
    
    // MARK: - For TabBarView
    @Binding var isShowingNewTweetView: Bool
    @Binding var isShowingNewMessageView: Bool
    @Binding var selectedIndex: Int

    
    var body: some View {
        ScrollViewReader { scrollView in
            NavigationView {
                VStack {
                    HStack {
                        Button(action: {
                            self.showSidebar.toggle()
                        }, label: {
                            if let user = AuthViewModel.shared.user {
                                AsyncImage(
                                    url: URL(string: user.profileImageUrl)!,
                                    placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                    image: { Image(uiImage: $0).resizable()}
                                )
                                    .scaledToFill()
                                    .clipped()
                                    .frame(width: 35, height: 35)
                                    .cornerRadius(16)
                            }
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                scrollView.scrollTo(viewModel.tweets.first?.id)
                            }
                            
                        }, label: {
                            Image("NWNLogo")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }).buttonStyle(FlatLinkStyle())
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                globalIconDisabled = true
                                scrollView.scrollTo(viewModel.tweets.first?.id)
                                onlyFollowing.toggle()
                                DispatchQueue.main.async() {
                                    viewModel.fetchTweets(onlyFollowing: onlyFollowing)
                                }
                                if globalIconToast {
                                    globalIconToast = false
                                    globalIconToast = true
                                } else {
                                    globalIconToast = true
                                }
                            }
                            
                        }, label: {
                            Group {
                                Image(systemName: onlyFollowing ? "person.3.fill" : "network")
                                    .font(.system(size: onlyFollowing ? 20 : 25, weight: .bold))
                                    .foregroundColor(Color("NWgray"))
                            }
                            .frame(width: 35, height: 35)
                            
                        })
                            .buttonStyle(FlatLinkStyle()).disabled(globalIconDisabled)
                            .onChange(of: self.globalIconDisabled) { newValue in
                                if newValue {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                                        self.globalIconDisabled = false
                                    }
                                }
                            }
                    }
                    .padding(.vertical, 1)
                    .padding(.horizontal, 15)
                    .frame(width: UIScreen.main.bounds.width, height: 40)
                    .padding(.top, 50)
                    ScrollView {
                        VStack {
                            PullToRefreshView {
                                self.viewModel.loadingNow = true
                                DispatchQueue.main.async() {
                                    self.viewModel.fetchTweets(onlyFollowing: onlyFollowing)
                                }
                            }
                            ForEach(Array(viewModel.tweets.enumerated()), id: \.offset) { tweetIndex, tweet in
                                ForEach(viewModel.users) { user in
                                    if user.id == tweet.uid {
                                        LazyVStack(alignment: .center) {
                                            TweetBlockView(tweet: tweet, user: user, tweetUploaded: $newTweetUploaded)
                                                .id(tweet.id)
                                            Divider()
                                            let tweetIndex = tweetIndex + 1
                                            let adPerCount = 4
                                            if tweetIndex % adPerCount == 0 {
                                                BannerVC(unitNumber: ((tweetIndex/adPerCount)-1))
                                                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 60, alignment: .center)
                                                Divider()
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 3)
                        }
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                    }
                    .onChange(of: newTweetUploaded) { value in
                        if value == true {
                            self.viewModel.loadingNow = true
                            DispatchQueue.main.async() {
                                self.viewModel.fetchTweets(onlyFollowing: onlyFollowing)
                            }
                            newTweetUploaded = false
                        }
                        
                    }
                    .padding(.vertical, 1)
                    .background(Color("NWbackground").scaledToFill())

                    TabBarView(isShowingNewTweetView: $isShowingNewTweetView, isShowingNewMessageView: $isShowingNewMessageView, selectedIndex: $selectedIndex)
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .background(Color("NWtoolbar"))
                .edgesIgnoringSafeArea(.all)
                
            }
            .onChange(of: viewModel.tweets.first?.id) { _ in
                withAnimation {
                    scrollView.scrollTo(viewModel.tweets.first?.id)
                }
            }
            
        }
        .onChange(of: viewModel.loadingNow, perform: { value in
            if value == true {
                self.loadingToast = value
            } else {
                self.loadingToast = value
                self.refreshToast.toggle()
            }
        })
        .toast(isPresenting: $globalIconToast, message: onlyFollowing ? "Only Followed" : "Global", icon: .info, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
        .toast(isPresenting: $loadingToast, message: "Loading", icon: .loading, backgroundColor: Color("NWgray"), autoDismiss: .after(5))
        .toast(isPresenting: $refreshToast, message: "Refreshed", icon: .info, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
    }
}


