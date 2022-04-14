//
//  UserCell.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 15.08.2021.
//

import SwiftUI

struct UserCell: View {
    let user: User
    
    var body: some View {
        if !AuthViewModel.shared.checkUidForBlock(userUid: self.user.id) {
            HStack(spacing: 12) {
                AsyncImage(
                    url: URL(string: user.profileImageUrl)!,
                    placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                    image: { Image(uiImage: $0).resizable()}
                )
                    .scaledToFill()
                    .clipped()
                    .frame(width: 56, height: 56)
                    .cornerRadius(28)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.fullname)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("@\(user.username)")
                        .font(.system(size: 14))
                        .foregroundColor(Color("NWgray"))
                }
                .foregroundColor(.black)
            }
        }
    }
}
