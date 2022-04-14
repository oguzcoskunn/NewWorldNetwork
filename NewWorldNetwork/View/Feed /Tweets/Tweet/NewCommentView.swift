//
//  NewCommentView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 4.09.2021.
//


import SwiftUI
import ToastSwiftUI

struct NewCommentView: View {
    @State private var loadingToast: Bool = false
    @State private var captionToast: Bool = false
    
    let tweet: Tweet
    @Binding var isPresented: Bool
    @Binding var replyUploaded: Bool
    @State var captionText: String = ""
    @ObservedObject var viewModel: UploadReplyViewModel
    @State var selectedUIImage: UIImage?

    init(tweet: Tweet ,isPresented: Binding<Bool> , replyUploaded: Binding<Bool>) {
        self.tweet = tweet
        self._isPresented = isPresented
        self._replyUploaded = replyUploaded
        self.viewModel = UploadReplyViewModel(tweet: tweet, isPresented: isPresented, replyUploaded: replyUploaded)
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Color("NWbackground")
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment : .leading) {
                    HStack {
                        Button(action: { isPresented.toggle() }, label: {
                            Image(systemName: "multiply")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 15, height: 15)
                                .foregroundColor(Color("NWorange"))
                        })
                        Spacer()
                        Button(action: {
                            self.viewModel.loadingNow = true
                            if let currentImage = selectedUIImage {
                                viewModel.replyTweetwithImage(caption: captionText, selectedImage: currentImage)
                            } else {
                                if !captionText.isEmpty {
                                    viewModel.replyTweet(caption: captionText)
                                } else {
                                    self.captionToast.toggle()
                                }
                            }
                        }, label: {
                            Text("Reply")
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color("NWorange"))
                                .foregroundColor(.black)
                                .clipShape(Capsule())
                        })
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 20)
                    HStack(spacing: 1) {
                        Text("Replying to ")
                        Text("@\(tweet.username)")
                            .fontWeight(.bold)
                            .foregroundColor(Color("NWorange"))
                        Spacer()
                    }
                    .font(.system(size: 16))
                    Divider()
                    HStack(alignment: .top) {
                        if let user = AuthViewModel.shared.user {
                            AsyncImage(
                                url: URL(string: user.profileImageUrl)!,
                                placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                image: { Image(uiImage: $0).resizable()}
                            )
                                .scaledToFill()
                                .clipped()
                                .frame(width: 64, height: 64)
                                .cornerRadius(32)
                        }
                        TextArea("Reply the post", text: $captionText, selectedUIImage: $selectedUIImage)
                        Spacer()
                    }
                    .padding(.top, 10)
                }.padding(.horizontal, 15)
            }
            .navigationBarHidden(true)
        }
        .onChange(of: self.viewModel.loadingNow, perform: { value in
            self.loadingToast = value
        })
        .toast(isPresenting: $loadingToast, message: "Loading", icon: .loading, backgroundColor: Color("NWgray"), autoDismiss: .after(5))
        .toast(isPresenting: $captionToast, message: "Enter Text!", icon: .none, backgroundColor: Color("NWgray"), autoDismiss: .after(3))
    }
}
