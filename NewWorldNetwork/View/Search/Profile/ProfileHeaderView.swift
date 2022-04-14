//
//  ProfileHeaderView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 23.08.2021.
//

import SwiftUI

struct ProfileHeaderView: View {
    @State var selectedFilter: TweetFilterOptions = .tweets
    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var isPresented: ActiveSheet?
    
    @State var user: User
    @State var showProfile = false
    @State var showFollowersView: Bool = false
    @State var showFollowingView: Bool = false
    @State var selectedFilterFollowers: FollowStatsFilterOption = .followers
    @State var selectedFilterFollowing: FollowStatsFilterOption = .following
    
    @State var editingProfile: Bool = false
    
    @State var editingProfilePhoto: Bool = false
    
    @State var editingName: Bool = false
    @State var nameText = ""
    
    @State var editingAboutMe: Bool = false
    @State var aboutMeText = ""
    
    @Binding var selectedUIImage: UIImage?
    @Binding var image: Image?
    
    @State var doRefresh: Bool = true
    
    
    var body: some View {
        ZStack {
            if let user = user {
                NavigationLink(
                    destination: LazyView(UserProfileView(user: user, isActive: $showProfile)),
                    isActive: $showProfile,
                    label: {})
            }
            VStack {
                if editingProfile {
                    ZStack(alignment: .trailing) {
                        if editingProfilePhoto {
                            Button(action: { isPresented = .first }, label: {
                                ZStack {
                                    if let image = image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .clipped()
                                            .frame(width: 120, height: 120)
                                            .cornerRadius(120/2)
                                            .shadow(color: Color("NWgray"), radius: 6, x: 0.0, y: 0.0)
                                    } else {
                                        Image("plus_photo")
                                            .resizable()
                                            .scaledToFill()
                                            .clipped()
                                            .frame(width: 120, height: 120)
                                            .cornerRadius(120/2)
                                    }
                                }
                            })
                        } else {
                            if viewModel.user.isCurrentUser {
                                if let user = authViewModel.user {
                                    AsyncImage(
                                        url: URL(string: user.profileImageUrl)!,
                                        placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                        image: { Image(uiImage: $0).resizable()}
                                    )
                                        .scaledToFill()
                                        .clipped()
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(120/2)
                                        .shadow(color: Color("NWgray"), radius: 6, x: 0.0, y: 0.0)
                                }
                            } else {
                                AsyncImage(
                                    url: URL(string: viewModel.user.profileImageUrl)!,
                                    placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                    image: { Image(uiImage: $0).resizable()}
                                )
                                    .scaledToFill()
                                    .clipped()
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(120/2)
                                    .shadow(color: Color("NWgray"), radius: 6, x: 0.0, y: 0.0)
                            }
                            
                        }
                        if editingProfile {
                            Button {
                                self.image = nil
                                self.selectedUIImage = nil
                                editingProfilePhoto.toggle()
                            } label: {
                                Image(systemName: editingProfilePhoto ? "multiply.circle.fill" : "pencil.circle.fill")
                                    .foregroundColor(Color("NWorange"))
                                    .offset(x: 10, y: -10)
                                    .font(.system(size: 20))
                            }
                            .offset(x: 30)
                        }
                    }
                    
                } else {
                    if viewModel.user.isCurrentUser {
                        if let user = authViewModel.user {
                            if doRefresh {
                                NavigationLink(
                                    destination: ImageFullScreenView(imageUrl: user.profileImageUrl),
                                    label: {
                                        AsyncImage(
                                            url: URL(string: user.profileImageUrl)!,
                                            placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                            image: { Image(uiImage: $0).resizable()}
                                        )
                                            .scaledToFill()
                                            .clipped()
                                            .frame(width: 120, height: 120)
                                            .cornerRadius(120/2)
                                            .shadow(color: Color("NWgray"), radius: 6, x: 0.0, y: 0.0)
                                    }).buttonStyle(FlatLinkStyle())
                                    .onChange(of: user.profileImageUrl) { newValue in
                                        doRefresh.toggle()
                                    }
                            } else {
                                NavigationLink(
                                    destination: ImageFullScreenView(imageUrl: user.profileImageUrl),
                                    label: {
                                        AsyncImage(
                                            url: URL(string: user.profileImageUrl)!,
                                            placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                            image: { Image(uiImage: $0).resizable()}
                                        )
                                            .scaledToFill()
                                            .clipped()
                                            .frame(width: 120, height: 120)
                                            .cornerRadius(120/2)
                                            .shadow(color: Color("NWgray"), radius: 6, x: 0.0, y: 0.0)
                                    }).buttonStyle(FlatLinkStyle())
                                    .onChange(of: user.profileImageUrl) { newValue in
                                        doRefresh.toggle()
                                    }
                            }
                        }
                    } else {
                        ZStack(alignment: .trailing) {
                            NavigationLink(
                                destination: ImageFullScreenView(imageUrl: viewModel.user.profileImageUrl),
                                label: {
                                    AsyncImage(
                                        url: URL(string: viewModel.user.profileImageUrl)!,
                                        placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                        image: { Image(uiImage: $0).resizable()}
                                    )
                                        .scaledToFill()
                                        .clipped()
                                        .frame(width: 120, height: 120)
                                        .cornerRadius(120/2)
                                        .shadow(color: Color("NWgray"), radius: 6, x: 0.0, y: 0.0)
                                }).buttonStyle(FlatLinkStyle())
                            
                            if viewModel.user.id != "mCJlIwtHQHRb6zPIBcfLTWX9vdY2" {
                                Button {
                                    isPresented = .second
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(Color("NWgray"))
                                        .rotationEffect(.degrees(-90))
                                }
                                .offset(x: 80, y:-40)
                            } else {
                                Text("Support")
                                    .font(.system(size: 15))
                                    .padding(.horizontal, 5)
                                    .foregroundColor(.black)
                                    .background(Color("NWorange"))
                                    .clipped()
                                    .cornerRadius(15)
                                    .offset(x: 60, y:-55)
                            }
                        }
                    }
                }
                ZStack(alignment: .trailing) {
                    if editingName {
                        TextField("", text: $nameText)
                            .placeholder(when: nameText.isEmpty, alignment: .center) {
                                Text("New Name...")
                                    .foregroundColor(.black)
                            }
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 15)
                            .foregroundColor(.black)
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: 30)
                            .background(Color("NWorange"))
                            .clipped()
                            .cornerRadius(15)
                            .font(.system(size: 16))
                    } else {
                        if viewModel.user.isCurrentUser {
                            if let user = authViewModel.user {
                                Text(user.fullname)
                                    .foregroundColor(Color(.white))
                                    .font(.system(size: 16, weight: .semibold))
                            }
                        } else {
                            Text(viewModel.user.fullname)
                                .foregroundColor(Color(.white))
                                .font(.system(size: 16, weight: .semibold))
                        }
                        
                    }
                    
                    
                    if editingProfile {
                        Button {
                            nameText = ""
                            editingName.toggle()
                        } label: {
                            Image(systemName: editingName ? "multiply.circle.fill" : "pencil.circle.fill")
                                .foregroundColor(Color("NWorange"))
                                .font(.system(size: 20))
                            
                        }
                        .offset(x: 30)
                    }
                }
                .padding(.top, 8)
                
                Text("@\(viewModel.user.username)")
                    .font(.subheadline)
                    .foregroundColor(Color("NWgray"))
                
                ZStack(alignment: .trailing) {
                    if editingAboutMe {
                        TextField("", text: $aboutMeText)
                            .placeholder(when: aboutMeText.isEmpty, alignment: .center) {
                                Text("New About Me...")
                                    .foregroundColor(.black)
                            }
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 15)
                            .foregroundColor(.black)
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: 30)
                            .background(Color("NWorange"))
                            .clipped()
                            .cornerRadius(15)
                        
                    } else {
                        if viewModel.user.isCurrentUser {
                            if let user = authViewModel.user {
                                Text(viewModel.user.aboutme.isEmpty ? "About Me" : user.aboutme)
                                    .foregroundColor(Color(.white))
                            }
                        } else {
                            Text(viewModel.user.aboutme.isEmpty ? "About Me" : viewModel.user.aboutme)
                                .foregroundColor(Color(.white))
                        }
                        
                    }
                    if editingProfile {
                        Button {
                            aboutMeText = ""
                            editingAboutMe.toggle()
                        } label: {
                            Image(systemName: editingAboutMe ? "multiply.circle.fill" : "pencil.circle.fill")
                                .foregroundColor(Color("NWorange"))
                                .font(.system(size: 20))
                        }
                        .offset(x: 30)
                    }
                }
                .font(.system(size: 14))
                .padding(.top, 8)
                .padding(.horizontal, 40)
                
                if viewModel.user.id != "mCJlIwtHQHRb6zPIBcfLTWX9vdY2" {
                    HStack(spacing: 40) {
                        if #available(iOS 15.0, *) {
                            Button {
                                showFollowersView.toggle()
                            } label: {
                                VStack {
                                    Text("\(viewModel.user.stats.followers)")
                                        .font(.system(size: 16)).bold()
                                        .foregroundColor(.white)
                                    Text("Followers")
                                        .font(.footnote)
                                        .foregroundColor(Color("NWgray"))
                                }
                            }.sheet(isPresented: $showFollowersView) {
                                FollowStatsView(currentUser: viewModel.user, showFollowersView: $showFollowersView, showFollowingView: $showFollowingView, showProfile: $showProfile, user: $user, selectedFilter: $selectedFilterFollowers, paddingTopValue: 0)
                                    .onDisappear {
                                        selectedFilterFollowers = .followers
                                    }
                            }

                            Button {
                                showFollowingView.toggle()
                            } label: {
                                VStack {
                                    Text("\(viewModel.user.stats.following)")
                                        .font(.system(size: 16)).bold()
                                        .foregroundColor(.white)
                                    Text("Following")
                                        .font(.footnote)
                                        .foregroundColor(Color("NWgray"))
                                }
                            }.sheet(isPresented: $showFollowingView) {
                                FollowStatsView(currentUser: viewModel.user, showFollowersView: $showFollowersView, showFollowingView: $showFollowingView, showProfile: $showProfile, user: $user, selectedFilter: $selectedFilterFollowing, paddingTopValue: 0)
                                    .onDisappear {
                                        selectedFilterFollowing = .following
                                    }
                            }
                        } else {
                            NavigationLink(
                                destination:
                                    FollowStatsView(currentUser: viewModel.user, showFollowersView: $showFollowersView, showFollowingView: $showFollowingView, showProfile: $showProfile, user: $user, selectedFilter: $selectedFilterFollowers, paddingTopValue: 120)
                                    .navigationBarTitle("")
                                        .onDisappear {
                                            selectedFilterFollowers = .followers
                                        }
                                ,
                                isActive: $showFollowersView,
                                label: {
                                    VStack {
                                        Text("\(viewModel.user.stats.followers)")
                                            .font(.system(size: 16)).bold()
                                            .foregroundColor(.white)
                                        Text("Followers")
                                            .font(.footnote)
                                            .foregroundColor(Color("NWgray"))
                                    }
                                })
                            
                            NavigationLink(
                                destination:
                                    FollowStatsView(currentUser: viewModel.user, showFollowersView: $showFollowersView, showFollowingView: $showFollowingView, showProfile: $showProfile, user: $user, selectedFilter: $selectedFilterFollowing, paddingTopValue: 120)
                                    .navigationBarTitle("")
                                        .onDisappear {
                                            selectedFilterFollowing = .following
                                        }
                                ,
                                isActive: $showFollowingView,
                                label: {
                                    VStack {
                                        Text("\(viewModel.user.stats.following)")
                                            .font(.system(size: 16)).bold()
                                            .foregroundColor(.white)
                                        Text("Following")
                                            .font(.footnote)
                                            .foregroundColor(Color("NWgray"))
                                    }
                                })
                        }
                        
                    }
                    .buttonStyle(FlatLinkStyle())
                .padding()
                }
                
                ProfileActionButtonView(viewModel: viewModel, editingProfile: $editingProfile, nameText: $nameText, aboutMeText: $aboutMeText, selectedUIImage: $selectedUIImage)
                
                Spacer()
            }
            .onDisappear(perform: {
                editingProfile = false
            })
            .onChange(of: editingProfile) { newValue in
                if newValue == false {
                    editingName = false
                    editingAboutMe = false
                    editingProfilePhoto = false
                }
        }
        }
    }
}
