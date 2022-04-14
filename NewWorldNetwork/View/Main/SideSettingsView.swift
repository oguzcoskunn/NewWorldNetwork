//
//  SideSettingsView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 10.10.2021.
//

import SwiftUI
import ToastSwiftUI

struct SideSettingsView: View {
    @State var showNotifAlert : Bool = false
    @State var notifAlertText : String = ""
    
    @State var showBlockedUsers : Bool = false
    @State var showNotifSettings : Bool = false
    @State var userUnblocked : Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            NavigationLink(
                destination: BlockedUsersView(userUnblocked: $userUnblocked),
                isActive: $showBlockedUsers,
                label: {})
            
            NavigationLink(
                destination: NotificationSettings(showNotifAlert: $showNotifAlert, notifAlertText: $notifAlertText),
                isActive: $showNotifSettings,
                label: {})
            Color("NWbackground")
            VStack(alignment: .leading, spacing: 25) {
                Text("Settings")
                    .font(.title3)
                    .foregroundColor(Color("NWorange"))
                Divider()
                    .padding(.bottom, 10)
                
                Button {
                    showBlockedUsers.toggle()
                } label: {
                    HStack(spacing: 15) {
                        Image(systemName: "person.crop.circle.fill.badge.minus")
                        Text("Blocked Users")
                    }
                }
                
                Button {
                    showNotifSettings.toggle()
                } label: {
                    HStack(spacing: 15) {
                        Image(systemName: "bell.circle.fill")
                        Text("Notification Settings")
                    }
                }

            }
            .foregroundColor(.white)
            .font(.system(size: 18))
            .padding(.vertical, 5)
            .padding(.horizontal, 25)
            .padding(.top, 100)
        }
        .toast(isPresenting: $showNotifAlert, message: self.notifAlertText, icon: .success, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
        .toast(isPresenting: $userUnblocked, message: "User Unblocked!", icon: .success, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
        .onChange(of: userUnblocked, perform: { newValue in
            print(newValue)
        })
        .navigationTitle("")
        .edgesIgnoringSafeArea(.all)
    }
}
