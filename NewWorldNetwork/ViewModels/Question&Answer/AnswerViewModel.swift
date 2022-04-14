//
//  AnswerViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 28.09.2021.
//

import SwiftUI

class AnswerViewModel: ObservableObject {
    let questionID: String
    @Published var answers = [Answer]()
    @Published var solution = [Answer]()
    
    init(questionID: String) {
        self.questionID = questionID
        fetchQuestionAnswers(questionID: questionID)
    }
    
    
    func fetchQuestionAnswers(questionID: String) {
        if !self.solution.isEmpty {
            self.solution.removeAll()
        }
        COLLECTION_QUESTIONS.document(questionID).collection("question-solution").document(questionID).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            self.solution.append(Answer(dictionary: data))
        }
        
        if !self.answers.isEmpty {
            self.answers.removeAll()
        }
        COLLECTION_QUESTIONS.document(questionID).collection("question-answers").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            documents.forEach { document in
                COLLECTION_QUESTIONS.document(questionID).collection("question-answers").document(document.documentID).collection("user-answers").getDocuments { snapshot, _ in
                    guard let replyDocuments = snapshot?.documents else { return }
                    replyDocuments.forEach { reply in
                        self.answers.append(Answer(dictionary: reply.data()))
                        self.answers.sort(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
                    }
                }
            }
        }
    }
    
}
