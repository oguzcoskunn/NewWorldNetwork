//
//  AnswerOptionsViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 29.09.2021.
//

import SwiftUI
import Firebase

class AnswerOptionsViewModel: ObservableObject {
    let question: Question
    @Binding var answerUploaded: Bool
    @Published var status: Int = 0
    
    init(question: Question ,answerUploaded: Binding<Bool>) {
        self.question = question
        self._answerUploaded = answerUploaded
        self.getStatus(question: question)
    }
    
    func removeSolution(question: Question ,answer: Answer) {
        let questionRef = COLLECTION_QUESTIONS.document(question.id)
        questionRef.getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            guard let questionStatus = data["status"] as? Int else { return }
            if questionStatus == 1 {
                let answerRef = COLLECTION_QUESTIONS.document(question.id).collection("question-answers").document(answer.uid).collection("user-answers").document(answer.id)
                answerRef.updateData(["solution": 0]) { _ in
                    questionRef.updateData(["status": 0]) { _ in
                        COLLECTION_QUESTIONS.document(question.id).collection("question-solution").document(question.id).delete()
                        self.answerUploaded.toggle()
                        
                    }
                }
            }
        }
    }
    
    func pickasSolution(question: Question ,answer: Answer) {
        let questionRef = COLLECTION_QUESTIONS.document(question.id)
        questionRef.getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            guard let questionStatus = data["status"] as? Int else { return }
            if questionStatus == 0 {
                let answerRef = COLLECTION_QUESTIONS.document(question.id).collection("question-answers").document(answer.uid).collection("user-answers").document(answer.id)
                answerRef.updateData(["solution": 1]) { _ in
                    questionRef.updateData(["status": 1]) { _ in
                        answerRef.getDocument { snapshot, _ in
                            guard let data = snapshot?.data() else { return }
                            COLLECTION_QUESTIONS.document(question.id).collection("question-solution").document(question.id).setData(data)
                            self.answerUploaded.toggle()
                        }
                    }
                }
            }
        }
    }
    
    func getStatus(question: Question) {
        let questionRef = COLLECTION_QUESTIONS.document(question.id)
        questionRef.getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            guard let questionStatus = data["status"] as? Int else { return }
            self.status = questionStatus
        }
    }
    
    func deleteAnswer(question: Question ,answer: Answer) {
        COLLECTION_QUESTIONS.document(question.id).collection("question-answers").document(answer.uid).collection("user-answers").document(answer.id).delete() { _ in
            let answersRef = COLLECTION_QUESTIONS.document(question.id)
            
            answersRef.getDocument { snapshot, _ in
                guard let data = snapshot?.data() else { return }
                guard let answerCount = data["answers"] as? Int else { return }
                
                answersRef.updateData(["answers": answerCount - 1]) { _ in
                    COLLECTION_QUESTIONS.document(question.id).collection("question-answers").document(answer.uid).collection("user-answers").getDocuments { snapshot, _ in
                        guard let answerDocuments = snapshot?.documents else { return }
                        if answerDocuments.count > 0 {
                            self.answerUploaded.toggle()
                        } else {
                            COLLECTION_QUESTIONS.document(question.id).collection("question-answers").document(answer.uid).delete() { _ in
                                self.answerUploaded.toggle()
                            }
                        }
                    }
                }
                
            }
        }
    }
}
