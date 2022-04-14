//
//  ReplyBlockView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 22.09.2021.
//

import SwiftUI

struct ReplyBlockView: View {
    @State var isProfileViewActive: Bool = false
    let user: User
    let reply: Reply
    let tweetID: String
    @ObservedObject var replyViewModel: ReplyViewModel
    
    var body: some View {
        if !AuthViewModel.shared.checkUidForBlock(userUid: self.reply.uid) {
            HStack(alignment: .top, spacing: 12) {
                NavigationLink(
                    destination: UserProfileView(user: user, isActive: $isProfileViewActive),
                    isActive: $isProfileViewActive,
                    label: {
                        AsyncImage(
                            url: URL(string: reply.profileImageUrl)!,
                            placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                            image: { Image(uiImage: $0).resizable()}
                        )
                            .scaledToFill()
                            .clipped()
                            .frame(width: 56, height: 56)
                            .cornerRadius(56 / 2)
                        
                    }).buttonStyle(FlatLinkStyle())
                ReplyCell(reply: reply, user: user, tweetID: tweetID, replyViewModel: replyViewModel)
            }
            .padding(.bottom, 1)
        }
        
    }
}

