//
//  BolockedUsersView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 2.10.2021.
//

import SwiftUI

struct BlockedUsersView: View {
    @State private var showUnblockAlert: Bool = false
    @State private var selectedUser: User?
    @State private var selectedUserFullName: String = ""
    @Binding var userUnblocked: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("NWbackground")
            VStack(alignment: .leading, spacing: 20) {
                Text("Blocked Users")
                    .font(.title3)
                    .foregroundColor(Color("NWorange"))
                Divider()
                    .padding(.bottom, 10)
                ScrollView {
                    if AuthViewModel.shared.blockedUsers.isEmpty {
                        Text("No Blocked Users...")
                            .foregroundColor(Color("NWgray"))
                    }
                    ForEach(AuthViewModel.shared.blockedUsers) { user in
                        HStack {
                            Button {
                                self.selectedUser = user
                                self.selectedUserFullName = user.fullname
                                self.showUnblockAlert.toggle()
                            } label: {
                                HStack {
                                    AsyncImage(
                                        url: URL(string: user.profileImageUrl)!,
                                        placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                        image: { Image(uiImage: $0).resizable()}
                                    )
                                        .scaledToFill()
                                        .clipped()
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(40/2)
                                        .padding(.bottom, 5)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(user.fullname)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.white)
                                        
                                        Text("@\(user.username)")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color("NWgray"))
                                    }
                                    
                                }
                                .foregroundColor(.white)
                            }
                            Spacer()
                        }
                    }
                }
                .alert(isPresented:$showUnblockAlert) {
                            Alert(
                                title: Text("Are you sure want to unblock '\(self.selectedUserFullName)'?"),
                                message: Text("If you unblock this user you will be able to see their content."),
                                primaryButton: .destructive(Text("Unblock")) {
                                    if let user = selectedUser {
                                        AuthViewModel.shared.unblockUser(userUid: user.id)
                                        self.presentationMode.wrappedValue.dismiss()
                                        self.userUnblocked = true
                                    }
                                },
                                secondaryButton: .cancel(Text("Cancel"))
                            )
                        }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 25)
            .padding(.top, 100)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
