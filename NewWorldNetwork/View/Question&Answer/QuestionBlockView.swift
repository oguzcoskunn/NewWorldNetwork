//
//  QuestionBlockView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 28.09.2021.
//

import SwiftUI

struct QuestionBlockView: View {
    @State var isProfileViewActive: Bool = false
    let question: Question
    let user: User
    @Binding var questionUploaded: Bool
    
    init(question: Question, user: User, questionUploaded: Binding<Bool>) {
        self.question = question
        self.user = user
        self._questionUploaded = questionUploaded
    }
    
    var body: some View {
        if !AuthViewModel.shared.checkUidForBlock(userUid: self.question.uid) {
            HStack(alignment: .top, spacing: 12) {
                NavigationLink(
                    destination:
                        LazyView(UserProfileView(user: user, isActive: $isProfileViewActive))
                    ,
                    isActive: $isProfileViewActive,
                    label: {
                        AsyncImage(
                           url: URL(string: user.profileImageUrl)!,
                           placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                           image: { Image(uiImage: $0).resizable()}
                        )
                            .scaledToFill()
                            .clipped()
                            .frame(width: 40, height: 40)
                            .cornerRadius(40 / 2)
                            .padding(.leading)
                    }).buttonStyle(FlatLinkStyle())
                NavigationLink(
                    destination: LazyView(QuestionDetailView(question: question, user: user)),
                    label: {
                        QuestionCell(question: question, user: user, questionUploaded: $questionUploaded)
                    }).buttonStyle(FlatLinkStyle())
            }
            .padding(.bottom, 1)
        }
    }
}


