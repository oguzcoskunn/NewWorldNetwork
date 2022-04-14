//
//  AnswerBlockView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 28.09.2021.
//

import SwiftUI

struct AnswerBlockView: View {
    @State var isProfileViewActive: Bool = false
    let user: User
    let answer: Answer
    let question: Question
    @Binding var answerUploaded: Bool
    
    var body: some View {
        if !AuthViewModel.shared.checkUidForBlock(userUid: self.answer.uid) {
            if answer.solution == 1 {
                VStack(alignment: .leading) {
                    HStack(spacing: 5) {
                        Image(systemName: "checkmark.seal.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("Solution!")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundColor(Color("NWorange"))
                    
                    HStack(alignment: .top, spacing: 12) {
                        NavigationLink(
                            destination: UserProfileView(user: user, isActive: $isProfileViewActive),
                            isActive: $isProfileViewActive,
                            label: {
                                AsyncImage(
                                    url: URL(string: user.profileImageUrl)!,
                                    placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                    image: { Image(uiImage: $0).resizable()}
                                )
                                    .scaledToFill()
                                    .clipped()
                                    .frame(width: 35, height: 35)
                                    .cornerRadius(35 / 2)
                                
                            }).buttonStyle(FlatLinkStyle())
                        AnswerCell(answerUploaded: $answerUploaded, answer: answer, question: question, user: user)
                    }
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("NWorange"), lineWidth: 2)
                    )
                }
            } else {
                HStack(alignment: .top, spacing: 12) {
                    NavigationLink(
                        destination: UserProfileView(user: user, isActive: $isProfileViewActive),
                        isActive: $isProfileViewActive,
                        label: {
                            AsyncImage(
                                url: URL(string: answer.profileImageUrl)!,
                                placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                image: { Image(uiImage: $0).resizable()}
                            )
                                .scaledToFill()
                                .clipped()
                                .frame(width: 35, height: 35)
                                .cornerRadius(35 / 2)
                            
                        }).buttonStyle(FlatLinkStyle())
                    AnswerCell(answerUploaded: $answerUploaded, answer: answer, question: question, user: user)
                }
                .padding(.bottom, 1)
            }
        }
    }
}


//if answer.solution == 1 {
//    Image(systemName: "checkmark.seal.fill")
//        .resizable()
//        .frame(width: 30, height: 30)
//        .foregroundColor(Color("NWorange"))
//        .rotationEffect(.degrees(-20))
//        .offset(y: -10)
//}
