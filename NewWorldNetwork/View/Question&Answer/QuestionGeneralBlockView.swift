//
//  QuestionGeneralBlockView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 2.10.2021.
//

import SwiftUI

struct QuestionGeneralBlockView: View {
    let question: Question
    let user: User
    @Binding var questionUploaded: Bool
    let questionIndex: Int
    
    var body: some View {
        if !AuthViewModel.shared.checkUidForBlock(userUid: self.question.uid) {
            QuestionBlockView(question: question, user: user, questionUploaded: $questionUploaded)
            Divider()
            let questionIndex = questionIndex + 1
            let adPerCount = 4
            if questionIndex % adPerCount == 0 {
                BannerVC(unitNumber: ((questionIndex/adPerCount)-1))
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 60, alignment: .center)
                Divider()
            }
        }
    }
}

