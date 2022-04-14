//
//  MessageView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 15.08.2021.
//

import SwiftUI

struct MessageView: View {
    let message : Message
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(message.text)
                    
                    Text(message.timestampString)
                        .foregroundColor(.black)
                        .font(.system(size: 10))
                        .multilineTextAlignment(.trailing)
                        .offset(y: 5)
                    
                }
                .padding()
                .background(Color("NWorange"))
                .clipShape(ChatBubble(isFromCurrentUser: true))
                .foregroundColor(.black)
                .padding(.horizontal)
            } else {
                HStack(alignment: .bottom) {
                    AsyncImage(
                        url: URL(string: message.user.profileImageUrl)!,
                        placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                        image: { Image(uiImage: $0).resizable()}
                    )
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(message.text)
                        
                        Text(message.timestampString)
                            .foregroundColor(.black)
                            .font(.system(size: 10))
                            .multilineTextAlignment(.leading)
                            .offset(y: 5)
                        
                    }
                    .padding()
                    .background(Color("NWgray"))
                    .clipShape(ChatBubble(isFromCurrentUser: false))
                    .foregroundColor(.black)
                }
                .padding(.horizontal)
//                .padding(.trailing, 100)
//                .padding(.leading, 16)
                Spacer()
            }
        }
    }
}
