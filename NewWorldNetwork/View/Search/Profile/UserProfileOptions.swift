//
//  UserProfileOptions.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 2.10.2021.
//

import SwiftUI

struct UserProfileOptions: View {
    let user: User
    @Binding var isPresented: ActiveSheet?
    @Binding var reportToast: Bool
    @Binding var blockToast: Bool
    @ObservedObject var reportViewModel = ReportViewModel()
    
    init(user: User, reportToast: Binding<Bool>, blockToast: Binding<Bool>, isPresented: Binding<ActiveSheet?>) {
        self.user = user
        self._reportToast = reportToast
        self._blockToast = blockToast
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if AuthViewModel.shared.userSession?.uid != self.user.id {
                HStack {
                    Button {
                        reportViewModel.blockUser(blockedUserUid: user.id)
                        self.blockToast.toggle()
                        isPresented = nil
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "multiply.circle.fill")
                            Text("Block the User")
                        }
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                    }
                    Spacer()
                }
            }
            
            if AuthViewModel.shared.userSession?.uid != self.user.id {
                HStack {
                    Button {
                        reportViewModel.reportTheContent(contentID: self.user.id, contentOwner: self.user.id, type: "user")
                        self.reportToast.toggle()
                        isPresented = nil
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "flag.fill")
                            Text("Report the User")
                        }
                        .font(.system(size: 18))
                    }
                    Spacer()
                }
            }
        
            
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.vertical, 5)
        .padding(.horizontal, 25)
        .padding(.top, 40)
    }
}
