//
//  Question&Answer.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 28.09.2021.
//

import SwiftUI
import ToastSwiftUI

struct QuestionAnswerView: View {
    @State private var refreshToast: Bool = false
    
    @ObservedObject var viewModel = QuestionAnswerViewModel()
    
    @Binding var showSidebar: Bool
    @Binding var questionUploaded: Bool
    
    // MARK: - For TabBarView
    @Binding var isShowingNewQuestion: Bool
    @Binding var isShowingNewMessageView: Bool
    @Binding var selectedIndex: Int
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationBarView(showSidebar: $showSidebar, title: "Question & Answer")
                ScrollView {
                    VStack {
                        PullToRefreshView {
                            DispatchQueue.main.async() {
                                self.viewModel.fetchQuestions()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                self.refreshToast.toggle()
                            }
                        }
                        ForEach(Array(viewModel.questions.enumerated()), id: \.offset) { questionIndex, question in
                            ForEach(viewModel.users) { user in
                                if user.id == question.uid {
                                    LazyVStack(alignment: .center) {
                                        QuestionGeneralBlockView(question: question, user: user, questionUploaded: $questionUploaded, questionIndex: questionIndex)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 3)
                    }
                    .padding(.top, 10)
                    .padding(.trailing, 10)
                }
                .onChange(of: questionUploaded) { value in
                    if value == true {
                        DispatchQueue.main.async() {
                            self.viewModel.fetchQuestions()
                        }
                        questionUploaded = false
                        
                    }
                    
                }
                .padding(.vertical, 1)
                .background(Color("NWbackground").scaledToFill())
//                .navigationBarTitleDisplayMode(.inline)

                QuestionAnswerTabView(isShowingNewQuestion: $isShowingNewQuestion, isShowingNewMessageView: $isShowingNewMessageView, selectedIndex: $selectedIndex)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .background(Color("NWtoolbar"))
            .edgesIgnoringSafeArea(.all)
        }
        .toast(isPresenting: $refreshToast, message: "Refreshed", icon: .info, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
    }
}
