//
//  QuestionOptionsView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 28.09.2021.
//


import SwiftUI

struct QuestionOptionsView: View {
    let question: Question
    @Binding var isPresented: Bool
    @Binding var reportToast: Bool
    @Binding var reportandBlockToast: Bool
    @Binding var questionUploaded: Bool
    @State private var showBlockAlert: Bool = false
    @ObservedObject var viewModel: QuestionOptionsViewModel
    @ObservedObject var reportViewModel = ReportViewModel()
    
    init(question: Question, questionUploaded: Binding<Bool>, reportToast: Binding<Bool>, reportandBlockToast: Binding<Bool>, isPresented: Binding<Bool>) {
        self.question = question
        self._questionUploaded = questionUploaded
        self._reportToast = reportToast
        self._isPresented = isPresented
        self._reportandBlockToast = reportandBlockToast
        self.viewModel = QuestionOptionsViewModel(questionUploaded: questionUploaded)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if AuthViewModel.shared.userSession?.uid != question.uid {
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
                            reportViewModel.reportTheContentandBlockUser(contentID: self.question.id, contentOwner: self.question.uid, type: "question")
                            self.reportandBlockToast.toggle()
                            isPresented.toggle()
                        },
                        secondaryButton: .cancel(Text("Report User")) {
                            reportViewModel.reportTheContent(contentID: self.question.id, contentOwner: self.question.uid, type: "question")
                            self.reportToast.toggle()
                            isPresented.toggle()
                        }
                    )
                }
            }
            
            if AuthViewModel.shared.userSession?.uid == question.uid {
                HStack {
                    Button {
                        viewModel.deleteQuestion(question: question)
                        isPresented.toggle()
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "multiply.circle")
                            Text("Delete the Question")
                        }
                        .font(.system(size: 18))
                    }
                    Spacer()
                }
                
            }
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.vertical, 5)
        .padding(.horizontal, 25)
        .padding(.top, 40)
    }
}
