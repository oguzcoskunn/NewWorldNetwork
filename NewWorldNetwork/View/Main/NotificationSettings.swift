//
//  NotificationSettings.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 9.10.2021.
//


import SwiftUI
import OneSignal

struct NotificationSettings: View {
    @Binding var showNotifAlert: Bool
    @Binding var notifAlertText:  String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("NWbackground")
            VStack(alignment: .leading, spacing: 20) {
                Text("Notification Settings")
                    .font(.title3)
                    .foregroundColor(Color("NWorange"))
                Divider()
                    .padding(.bottom, 10)
                
                VStack(spacing: 25) {
                    Button {
                        OneSignal.disablePush(false)
                        self.presentationMode.wrappedValue.dismiss()
                        self.notifAlertText = "Notifications Turned On"
                        self.showNotifAlert = true
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "bell.fill")
                            Text("Turn On")
                        }
                    }

                    Button {
                        OneSignal.disablePush(true)
                        self.presentationMode.wrappedValue.dismiss()
                        self.notifAlertText = "Notifications Turned Off"
                        self.showNotifAlert = true
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "bell.slash.fill")
                            Text("Turn Off")
                        }
                        .foregroundColor(Color(.red))
                    }
                }
                .foregroundColor(.white)
                .font(.system(size: 18))
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 25)
            .padding(.top, 100)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
