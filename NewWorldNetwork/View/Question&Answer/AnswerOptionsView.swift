//
//  AnswerOptionsView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 29.09.2021.
//

import SwiftUI

struct AnswerOptionsView: View {
    let answer: Answer
    let question: Question
    @Binding var isPresented: Bool
    @Binding var answerUploaded: Bool
    @Binding var reportToast: Bool
    @Binding var reportandBlockToast: Bool
    @State private var showBlockAlert: Bool = false
    @ObservedObject var viewModel: AnswerOptionsViewModel
    @ObservedObject var reportViewModel = ReportViewModel()
    
    let paddingTopValue: CGFloat
    
    init(answer: Answer, question: Question, answerUploaded: Binding<Bool>, reportToast: Binding<Bool>, reportandBlockToast: Binding<Bool>, isPresented: Binding<Bool>, paddingTopValue: CGFloat) {
        self.answer = answer
        self.question = question
        self._answerUploaded = answerUploaded
        self._reportToast = reportToast
        self._reportandBlockToast = reportandBlockToast
        self._isPresented = isPresented
        self.viewModel = AnswerOptionsViewModel(question: question, answerUploaded: answerUploaded)
        self.paddingTopValue = paddingTopValue
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 25) {
                
                if AuthViewModel.shared.userSession?.uid != answer.uid {
                    HStack {
                        Button {
                            showBlockAlert.toggle()
                        } label: {
                            HStack(spacing: 15) {
                                Image(systemName: "flag.fill")
                                Text("Report the User")
                            }
                            .font(.system(size: 18))
                        }
                        Spacer()
                    }
                    .alert(isPresented:$showBlockAlert) {
                        Alert(
                            title: Text("Do you also want to block this user?"),
                            message: Text("If you block this user you will not be able to see their content."),
                            primaryButton: .destructive(Text("Report & Block User")) {
                                reportViewModel.reportTheContentandBlockUser(contentID: self.answer.id, contentOwner: self.answer.uid, type: "answer")
                                self.reportandBlockToast.toggle()
                                isPresented.toggle()
                            },
                            secondaryButton: .cancel(Text("Report User")) {
                                reportViewModel.reportTheContent(contentID: self.answer.id, contentOwner: self.answer.uid, type: "answer")
                                self.reportToast.toggle()
                                isPresented.toggle()
                            }
                        )
                    }
                }
                
                if answer.solution == 1 && AuthViewModel.shared.userSession?.uid == question.uid {
                    Button {
                        isPresented.toggle()
                        viewModel.removeSolution(question: question, answer: answer)
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "checkmark.seal")
                            Text("Remove Solution")
                        }
                        .font(.system(size: 18))
                        .foregroundColor(Color(.red))
                    }
                }
                
                if AuthViewModel.shared.userSession?.uid == question.uid && viewModel.status == 0 {
                    Button {
                        isPresented.toggle()
                        viewModel.pickasSolution(question: question, answer: answer)
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "checkmark.seal.fill")
                            Text("Pick as Solution")
                        }
                        .font(.system(size: 18))
                        .foregroundColor(Color("NWorange"))
                    }
                }
                if AuthViewModel.shared.userSession?.uid == answer.uid && answer.solution == 0 {
                    Button {
                        isPresented.toggle()
                        viewModel.deleteAnswer(question: question, answer: answer)
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "multiply.circle")
                            Text("Delete the Answer")
                        }
                        .font(.system(size: 18))
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.vertical, 5)
        .padding(.horizontal, 25)
        .padding(.top, paddingTopValue)
    }
}
