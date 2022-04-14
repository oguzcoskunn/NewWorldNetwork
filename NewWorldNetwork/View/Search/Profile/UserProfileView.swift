//
//  UserProfileView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 23.08.2021.
//

import SwiftUI
import Firebase
import ToastSwiftUI

enum ActiveSheet: Identifiable {
    case first, second
    
    var id: Int {
        hashValue
    }
}

struct UserProfileView: View {
    let user: User
    @ObservedObject var viewModel: ProfileViewModel
    @ObservedObject var searchView = SearchViewModel(config: .search)
    @State var selectedFilter: TweetFilterOptions = .tweets
    @State var uploadedTweet = false
    
    @State var reportToast: Bool = false
    @State var blockToast: Bool = false
    
    @State var image: Image?
    @State var selectedUIImage: UIImage?
    
    @State var activeSheet: ActiveSheet?
    
    @Binding var isActive: Bool
    
    init(user: User, isActive: Binding<Bool>) {
        self.user = user
        self._isActive = isActive
        self.viewModel = ProfileViewModel(user: user)
    }
    
    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        image = Image(uiImage: selectedImage)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ProfileHeaderView(viewModel: viewModel, isPresented: $activeSheet, user: user, selectedUIImage: $selectedUIImage, image: $image)
                    .padding(.horizontal)
                    .sheet(item: $activeSheet) { item in
                                switch item {
                                case .first:
                                    ImagePicker(image: $selectedUIImage)
                                        .onDisappear {
                                            loadImage()
                                        }
                                case .second:
                                    UserProfileOptions(user: user, reportToast: $reportToast, blockToast: $blockToast, isPresented: $activeSheet)
                                        .background(Color("NWtoolbar"))
                                        .edgesIgnoringSafeArea(.all)
                                }
                            }

                if user.id != "mCJlIwtHQHRb6zPIBcfLTWX9vdY2" {
                    FilterButtonView(selectedOption: $selectedFilter)
                        .padding()
                    
                    ForEach(viewModel.tweets(forFilter: selectedFilter)) { tweet in
                        ForEach(searchView.users) { user in
                            if user.id == tweet.uid {
                                LazyVStack(alignment: .leading, spacing: 1) {
                                    TweetBlockView(tweet: tweet, user: user, tweetUploaded: $uploadedTweet)
                                    Divider()
                                }
                                .padding(.trailing, 30)
                                .padding(.leading, 20)
                            }
                        }
                    }
                }
                
                
            }
            .padding(.top, 140)
            .padding(.bottom, 15)
            
        }
        .onChange(of: self.blockToast, perform: { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    AuthViewModel.shared.getBlockedUsers()
                    self.isActive.toggle()
                }
            }
        })
        .toast(isPresenting: $reportToast, message: "User reported!", icon: .success, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
        .toast(isPresenting: $blockToast, message: "User blocked!", icon: .success, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("")
        .background(Color("NWbackground").scaledToFill())
        .edgesIgnoringSafeArea(.all)
        
    }
}
