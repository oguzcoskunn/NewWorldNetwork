//
//  QuestionOptionsViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 28.09.2021.
//

import SwiftUI
import Firebase

class QuestionOptionsViewModel: ObservableObject {
    
    @Binding var questionUploaded: Bool
    
    init(questionUploaded: Binding<Bool>) {
        self._questionUploaded = questionUploaded
    }
    
    func deleteQuestion(question: Question) {
        let questionRef = COLLECTION_QUESTIONS.document(question.id)
        let questionAnswersRef = COLLECTION_QUESTIONS.document(question.id).collection("question-answers")
        let userQuestionRef = COLLECTION_USERS.document(question.uid).collection("user-questions").document(question.id)
        let userNotificationsAnswerRef = COLLECTION_USERS.document(question.uid).collection("user-notifications").document("answer-\(question.id)")

        userQuestionRef.delete() { _ in
            userNotificationsAnswerRef.delete() { _ in
                    questionRef.delete() { _ in
                        questionAnswersRef.getDocuments { snapshot, _ in
                            guard let documents = snapshot?.documents else { return }
                            documents.forEach { document in
                                COLLECTION_QUESTIONS.document(question.id).collection("question-answers").document(document.documentID).collection("user-answers").getDocuments { snapshot, _ in
                                    guard let replyDocuments = snapshot?.documents else { return }
                                    replyDocuments.forEach { reply in
                                        COLLECTION_QUESTIONS.document(question.id).collection("question-answers").document(document.documentID).collection("user-answers").document(reply.documentID).delete() { _ in
                                            COLLECTION_QUESTIONS.document(question.id).collection("question-answers").document(document.documentID).delete() { _ in
                                                COLLECTION_QUESTIONS.document(question.id).collection("question-solution").document(question.id).delete()
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        self.questionUploaded = true
                    }
                }
            
        }
    }
}
