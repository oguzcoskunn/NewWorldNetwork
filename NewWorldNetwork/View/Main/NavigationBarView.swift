//
//  NavigationBarView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 5.10.2021.
//

import SwiftUI

struct NavigationBarView: View {
    @Binding var showSidebar: Bool
    let title: String

    var body: some View {
        HStack {
            Button(action: {
                self.showSidebar.toggle()
            }, label: {
                if let user = AuthViewModel.shared.user {
                    AsyncImage(
                        url: URL(string: user.profileImageUrl)!,
                        placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                        image: { Image(uiImage: $0).resizable()}
                    )
                        .scaledToFill()
                        .clipped()
                        .frame(width: 35, height: 35)
                        .cornerRadius(16)
                }
            })
            
            Spacer()
            
            Text(self.title)
                .font(.title3)
                .foregroundColor(Color("NWorange"))
            
            Spacer()
            
            Group {
                Spacer()
            }.frame(width: 35, height: 35)
        }
        .padding(.vertical, 1)
        .padding(.horizontal, 15)
        .frame(width: UIScreen.main.bounds.width, height: 40)
        .padding(.top, 40)
    }
}

