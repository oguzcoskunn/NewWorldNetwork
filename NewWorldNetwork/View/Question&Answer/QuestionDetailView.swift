//
//  QuestionDetailView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 28.09.2021.
//

import SwiftUI

struct QuestionDetailView: View {
    @State var isProfileViewActive: Bool = false
    let question: Question
    let user: User
    
    @ObservedObject var viewModel: AnswerViewModel
    @ObservedObject var searchViewModel = SearchViewModel(config: .search)
    
    @State var answerUploaded: Bool = false
    @State var showNewAnswer: Bool = false
    
    init(question: Question, user: User){
        self.question = question
        self.user = user
        self.viewModel = AnswerViewModel(questionID: question.id)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading) {
                    NavigationLink(
                        destination: UserProfileView(user: user, isActive: $isProfileViewActive),
                        isActive: $isProfileViewActive,
                        label: {
                            HStack(alignment: .top){
                                HStack(alignment: .center) {
                                    AsyncImage(
                                        url: URL(string: user.profileImageUrl)!,
                                        placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                        image: { Image(uiImage: $0).resizable()}
                                    )
                                        .scaledToFill()
                                        .clipped()
                                        .frame(width: 56, height: 56)
                                        .cornerRadius(28)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(user.fullname)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.white)
                                        
                                        Text("@\(user.username)")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color("NWgray"))
                                    }
                                }
                                
                                Spacer()
                                HStack(alignment: .center, spacing: 5) {
                                    Text("Game:")
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(Color("NWgray"))
                                    Text("\(question.gameName)")
                                        .font(.system(size: 17))
                                        .padding(.horizontal, 8)
                                        .foregroundColor(.black)
                                        .background(Color("NWgray"))
                                        .clipped()
                                        .cornerRadius(20)
                                }
                            }
                        }).buttonStyle(FlatLinkStyle())
                    
                    Text(question.title)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                        .padding(.top, 5)
                    
                    if !question.caption.isEmpty {
                        Text(question.caption)
                            .font(.system(size: 16))
                            .foregroundColor(Color("NWgray"))
                    }
                    
                    if !question.imageUrl.isEmpty {
                        HStack {
                            NavigationLink(
                                destination: ImageFullScreenView(imageUrl: question.imageUrl),
                                label: {
                                    AsyncImage(
                                        url: URL(string: question.imageUrl)!,
                                        placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                        image: { Image(uiImage: $0).resizable()}
                                    )
                                        .scaledToFit()
                                        .clipped()
                                        .cornerRadius(20)
                                        .padding(.top, 5)
                                        .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
                                }).buttonStyle(FlatLinkStyle())
                            Spacer()
                        }
                       
                    }
                    
                    Divider()

                    Text(question.detailedTimestampString)
                        .font(.system(size: 14))
                        .foregroundColor(Color("NWgray"))
                        .padding(.top, 5)
                    
                    Divider()
                    
                    Button {
                        self.showNewAnswer.toggle()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "arrowshape.turn.up.left.fill")
                                .resizable()
                                .frame(width: 18, height: 12)
                            Text("Answer")
                                .font(.system(size: 15, weight: .semibold))
                        }
                        
                        .foregroundColor(Color("NWorange"))
                    }
                    .padding(.top, 10)

                }
                                
                if !viewModel.solution.isEmpty && viewModel.answers.count > 6 {
                    Divider()
                    ForEach(viewModel.solution) { solution in
                        ForEach(searchViewModel.users) { user in
                            if user.id == solution.uid {
                                LazyVStack(alignment: .leading) {
                                    AnswerBlockView(user: user, answer: solution, question: question, answerUploaded: $answerUploaded)
                                }
                            }
                        }
                    }
                }
                
                Divider()
                ForEach(viewModel.answers) { answer in
                    ForEach(searchViewModel.users) { user in
                        if user.id == answer.uid {
                            LazyVStack(alignment: .leading) {
                                AnswerBlockView(user: user, answer: answer, question: question, answerUploaded: $answerUploaded)
                                Divider()
                            }
                        }
                    }
                }
                .padding(.vertical, 3)
                
                
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.top, 100)
            .fullScreenCover(isPresented: $showNewAnswer) {
                NewAnswerView(question: self.question, isPresented: $showNewAnswer, answerUploaded: $answerUploaded)
            }
            .onChange(of: answerUploaded) { value in
                if value == true {
                    DispatchQueue.main.async() {
                        self.viewModel.fetchQuestionAnswers(questionID: self.question.id)
                    }
                    answerUploaded = false
                }
            }
        }
        .padding(.horizontal, 1)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("")
        .background(Color("NWbackground").scaledToFill())
        .edgesIgnoringSafeArea(.all)
        
    }
}
