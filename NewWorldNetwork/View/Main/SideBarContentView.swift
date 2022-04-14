//
//  SideBarContentView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 27.09.2021.
//

import SwiftUI
import ToastSwiftUI

struct SideBarContentView: View {
    @State var sendBugToast : Bool = false
    @State var showSettings : Bool = false
    
    let user: User
    @Binding var selectedIndex: Int
    @Binding var showSideBar: Bool
    @Binding var goProfile: Bool
    @Binding var goUser: User?
    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var doRefresh: Bool = true
    
    init(user: User, selectedIndex: Binding<Int>, showSideBar: Binding<Bool>, goProfile: Binding<Bool>, goUser: Binding<User?>) {
        self.user = user
        self._showSideBar = showSideBar
        self._goProfile = goProfile
        self.viewModel = ProfileViewModel(user: user)
        self._selectedIndex = selectedIndex
        self._goUser = goUser
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            NavigationLink(
                destination: SideSettingsView(),
                isActive: $showSettings,
                label: {})
            Color("NWbackground")
            VStack(alignment: .leading, spacing: 3) {
                Group {
                    if doRefresh {
                        Button {
                            self.goUser = self.user
                            self.showSideBar.toggle()
                            self.goProfile.toggle()
                        } label: {
                            AsyncImage(
                                url: URL(string: self.user.profileImageUrl)!,
                                placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                image: { Image(uiImage: $0).resizable()}
                            )
                                .scaledToFill()
                                .clipped()
                                .frame(width: 60, height: 60)
                                .cornerRadius(60/2)
                                .padding(.bottom, 5)
                        }
                        .onChange(of: self.user.profileImageUrl) { newValue in
                            doRefresh.toggle()
                        }
                    } else {
                        Button {
                            self.goUser = self.user
                            self.showSideBar.toggle()
                            self.goProfile.toggle()
                        } label: {
                            AsyncImage(
                                url: URL(string: self.user.profileImageUrl)!,
                                placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                image: { Image(uiImage: $0).resizable()}
                            )
                                .scaledToFill()
                                .clipped()
                                .frame(width: 60, height: 60)
                                .cornerRadius(60/2)
                                .padding(.bottom, 5)
                        }
                        .onChange(of: self.user.profileImageUrl) { newValue in
                            doRefresh.toggle()
                        }
                    }
                    
                    Text(self.user.fullname)
                        .foregroundColor(Color(.white))
                        .font(.system(size: 16, weight: .semibold))
                    Text("@\(self.user.username)")
                        .font(.subheadline)
                        .foregroundColor(Color("NWgray"))

                    
                    HStack(spacing: 20) {
                        VStack {
                            Text("\(viewModel.user.stats.followers)")
                                .font(.system(size: 16)).bold()
                                .foregroundColor(.white)
                            Text("Followers")
                                .font(.footnote)
                                .foregroundColor(Color("NWgray"))
                        }
                        
                        VStack {
                            Text("\(viewModel.user.stats.following)")
                                .font(.system(size: 16)).bold()
                                .foregroundColor(.white)
                            Text("Following")
                                .font(.footnote)
                                .foregroundColor(Color("NWgray"))
                        }
                    }
                    .padding(.top, 20)
                }
                
                
                Divider()
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                Button {
                    self.goUser = self.user
                    self.showSideBar.toggle()
                    self.goProfile.toggle()
                } label: {
                    HStack(spacing: 15) {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                }
                .font(.system(size: 18))
                .foregroundColor(.white)
                
                Divider()
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 25) {
                    if selectedIndex > 4 {
                        Button {
                            showSideBar.toggle()
                            selectedIndex = 0
                        } label: {
                            HStack(spacing: 15) {
                                Image(systemName: "network")
                                Text("Social")
                            }
                        }
                    } else {
                        Button {
                            showSideBar.toggle()
                            selectedIndex = 0
                        } label: {
                            HStack(spacing: 15) {
                                Image(systemName: "network")
                                Text("Social")
                            }
                            .foregroundColor(Color("NWorange"))
                        }
                    }
                    

                    if selectedIndex < 5 {
                        Button {
                            showSideBar.toggle()
                            selectedIndex = 5
                        } label: {
                            HStack(spacing: 15) {
                                Image(systemName: "person.fill.questionmark")
                                Text("Question & Answer")
                            }
                        }
                    } else {
                        Button {
                            showSideBar.toggle()
                            selectedIndex = 5
                        } label: {
                            HStack(spacing: 15) {
                                Image(systemName: "person.fill.questionmark")
                                Text("Question & Answer")
                            }
                            .foregroundColor(Color("NWorange"))
                        }
                    }
                    
                    Divider()

                    Button {
                        showSettings.toggle()
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                    }
                    
                }
                .font(.system(size: 18))
                .foregroundColor(.white)
                
                Divider()
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                         
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 25) {
                    Button {
                        self.goUser = self.authViewModel.supportUser
                        self.showSideBar.toggle()
                        self.goProfile.toggle()
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "ellipsis.bubble")
                            Text("Contact Us")
                        }
                    }
                    NavigationLink {
                        SendBugView(sendBugToast: $sendBugToast)
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "ant")
                            Text("Bug Report")
                        }
                    }
                    if #available(iOS 15.0, *) {
                        Button {
                            showSideBar.toggle()
                            authViewModel.signOut()
                        } label: {
                            HStack(spacing: 15) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Log Out")
                            }
                        }
                    } else {
                        Button {
                            showSideBar.toggle()
                            authViewModel.signOut()
                        } label: {
                            HStack(spacing: 15) {
                                Image(systemName: "arrow.backward.circle.fill")
                                Text("Log Out")
                            }
                        }
                    }
                    
                }
                .font(.system(size: 18))
                .foregroundColor(.white)
                .padding(.bottom, 40)
                
                
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 25)
            .padding(.top, 50)
        }
        .toast(isPresenting: $sendBugToast, message: "Report Sent", icon: .success, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
    }
}

