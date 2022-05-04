//
//  QuestionSearchView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 29.09.2021.
//


import SwiftUI

struct QuestionAnswerSearchView: View {
    @Binding var showSidebar: Bool
    @Binding var questionUploaded: Bool
    
    @State var gameSearchText = ""
    @State var titleSearchText = ""
    @ObservedObject var viewModel = QuestionAnswerViewModel()
    
    // MARK: - For TabBarView
    @Binding var isShowingNewQuestion: Bool
    @Binding var isShowingNewMessageView: Bool
    @Binding var selectedIndex: Int
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationBarView(showSidebar: $showSidebar, title: "Search Question")
                VStack {
                    HStack(alignment: .center) {
                        VStack(spacing: 30) {
                            Text("Title:")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color("NWorange"))
                            Text("Game:")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color("NWorange"))
                        }
                        
                        VStack(spacing: 20) {
                            QuestionAnswerSearchBar(placerholder: "Search For Title...", text: $titleSearchText)
                            .frame(width: UIScreen.main.bounds.width * 0.7, height: 25)
                            
                            QuestionAnswerSearchBar(placerholder: "Search For Game...", text: $gameSearchText)
                            .frame(width: UIScreen.main.bounds.width * 0.7, height: 25)
                        }
                        
                    }
                    .padding(.top, 20)
                    
                    Divider()
                        .padding(.top, 10)
                    
                    ScrollView {
                        VStack {
                            if viewModel.filterQuestions(titleSearchText, gameSearchText).isEmpty  {
                                Text("No Result...")
                                    .foregroundColor(Color("NWgray"))
                                    .padding(.top, 10)
                            }
                            
                            ForEach(viewModel.filterQuestions(titleSearchText, gameSearchText)) { question in
                                ForEach(viewModel.users) { user in
                                    if user.id == question.uid {
                                        LazyVStack(alignment: .leading) {
                                            QuestionBlockView(question: question, user: user, questionUploaded: $questionUploaded)
                                            Divider()
                                        }
                                    }
                                }
                                
                            }
                            .padding(.vertical, 3)
                        }
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

                }
                .background(Color("NWbackground").scaledToFill())
//                .navigationBarTitleDisplayMode(.inline)
                QuestionAnswerTabView(isShowingNewQuestion: $isShowingNewQuestion, isShowingNewMessageView: $isShowingNewMessageView, selectedIndex: $selectedIndex)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .background(Color("NWtoolbar"))
            .edgesIgnoringSafeArea(.all)
        }
    }
}
