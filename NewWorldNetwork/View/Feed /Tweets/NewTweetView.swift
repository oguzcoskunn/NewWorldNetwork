//
//  NewTweetView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 23.08.2021.
//

import SwiftUI
import ToastSwiftUI

struct NewTweetView: View {
    @State private var loadingToast: Bool = false
    @State private var captionToast: Bool = false
    @Binding var isPresented: Bool
    @State var captionText: String = ""
    @Binding var tweetUploaded: Bool
    @ObservedObject var viewModel: UploadTweetViewModel
    @State var selectedUIImage: UIImage?
    
    init(isPresented: Binding<Bool>, tweetUploaded: Binding<Bool>) {
        self._isPresented = isPresented
        self._tweetUploaded = tweetUploaded
        self.viewModel = UploadTweetViewModel(isPresented: isPresented, tweetUploaded: tweetUploaded)
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
                                viewModel.uploadTweetwithImage(caption: captionText, selectedImage: currentImage)
                            } else {
                                if !captionText.isEmpty {
                                    viewModel.uploadTweet(caption: captionText)
                                } else {
                                    self.captionToast.toggle()
                                }
                            }
                            
                        }, label: {
                            Text("Share")
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color("NWorange"))
                                .foregroundColor(.black)
                                .clipShape(Capsule())
                        })
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 20)
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
                        TextArea("What's happening?", text: $captionText, selectedUIImage: $selectedUIImage)
                    }
                }.padding(.horizontal, 15)
            }
            .navigationBarHidden(true)
        }
        .onChange(of: self.viewModel.loadingNow, perform: { value in
            self.loadingToast = value
        })
        .toast(isPresenting: $loadingToast, message: "Loading", icon: .loading, backgroundColor: Color("NWgray"), autoDismiss: .after(5))
        .toast(isPresenting: $captionToast, message: "Enter Text!", icon: .error, backgroundColor: Color("NWgray"), autoDismiss: .after(3))
    }
}
