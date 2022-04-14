//
//  ProfileActionButtonView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 23.08.2021.
//

import SwiftUI

struct ProfileActionButtonView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var editingProfile: Bool
    @Binding var nameText: String
    @Binding var aboutMeText: String
    @Binding var selectedUIImage: UIImage?
    
    var body: some View {
        
        if viewModel.user.isCurrentUser {
            HStack {
                if editingProfile {
                    Button(action: {
                        authViewModel.updateUser(fullname: nameText, aboutMe: aboutMeText, newProfileImage: selectedUIImage)
                        editingProfile.toggle()
                    }, label: {
                        Text("Save")
                            .frame(width: 180, height: 40)
                            .background(Color("NWorange"))
                            .foregroundColor(.black)
                    })
                        .cornerRadius(20)
                }
                
                Button(action: {
                    editingProfile.toggle()
                }, label: {
                    Text(editingProfile ? "Cancel Editing" : "Edit Profile")
                        .frame(width: editingProfile ? 180 : 360, height: 40)
                        .background(editingProfile ? Color("NWgray") : Color("NWorange"))
                        .foregroundColor(.black)
                })
                    .cornerRadius(20)
            }
        } else if viewModel.user.id != "mCJlIwtHQHRb6zPIBcfLTWX9vdY2" {
            HStack {
                Button(action: {
                    viewModel.user.isFollowed ? viewModel.unfollow() : viewModel.follow()
                }, label: {
                    Text(viewModel.user.isFollowed ? "Following" : "Follow")
                        .frame(width: 180, height: 40)
                        .background(viewModel.user.isFollowed ? Color("NWgray") : Color("NWorange"))
                        .foregroundColor(.black)
                })
                .cornerRadius(20)
                
                NavigationLink(
                    destination: LazyView(ChatView(user: viewModel.user).navigationBarHidden(true)),
                    label: {
                        Text("Message")
                            .frame(width: 180, height: 40)
                            .background(Color("NWorange"))
                            .foregroundColor(.black)
                    })
                    .cornerRadius(20)
            }
        } else {
            NavigationLink(
                destination: LazyView(ChatView(user: viewModel.user).navigationBarHidden(true)),
                label: {
                    Text("Message")
                        .frame(width: 360, height: 40)
                        .background(Color("NWorange"))
                        .foregroundColor(.black)
                })
                .cornerRadius(20)
                .padding(.top, 20)
        }
        
        
    }
}
