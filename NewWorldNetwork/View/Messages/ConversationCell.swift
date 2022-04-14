//
//  ConversationCell.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 15.08.2021.
//

import SwiftUI

struct ConversationCell: View {
    let message: Message
    
    var body: some View {
        if !AuthViewModel.shared.checkUidForBlock(userUid: self.message.fromId) {
            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    AsyncImage(
                        url: URL(string: message.user.profileImageUrl)!,
                        placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                        image: { Image(uiImage: $0).resizable()}
                    )
                        .scaledToFill()
                        .clipped()
                        .frame(width: 56, height: 56)
                        .cornerRadius(28)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 3) {
                            Text(message.user.fullname)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(.white))
                            Text("@\(message.user.username)")
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                            Text(message.timestampString)
                                .font(.system(size: 10))
                        }
                        
                        Text(message.text)
                            .font(.system(size: 15))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    .foregroundColor(Color("NWgray"))
                }
                Divider()
            }
        }
    }
}

