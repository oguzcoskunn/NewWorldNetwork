//
//  SolutionCellView.swift
//  NewWorldSocial
//
//  Created by Oğuz Coşkun on 29.09.2021.
//

import SwiftUI

struct SolutionCellView: View {
    let user: User
    let answer: Answer
    let question: Question
    @Binding var answerUploaded: Bool
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            
            
            AnswerBlockView(user: user, answer: answer, question: question, answerUploaded: $answerUploaded)            
        }
        
    }
}


