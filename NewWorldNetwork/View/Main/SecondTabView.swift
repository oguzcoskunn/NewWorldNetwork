//
//  SecondTabView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 4.05.2022.
//

import SwiftUI

struct SecondTabView: View {
    @Binding var selectedIndex: Int
    @Binding var showSidebar: Bool
    
    @State var isShowingNewMessageView = false
    @State var newTweetUploaded = false
    @State var questionUploaded = false
    @State var isShowingNewQuestion = false
    
    @State var showChat = false
    @State var user: User?
    @State var isShowingNewTweetView = false
    
    init(selectedIndex: Binding<Int>, showSidebar: Binding<Bool>) {
        self._selectedIndex = selectedIndex
        self._showSidebar = showSidebar
        UITabBar.appearance().isHidden = true
    }
    
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            QuestionAnswerView(showSidebar: $showSidebar, questionUploaded: $questionUploaded, isShowingNewQuestion: $isShowingNewQuestion, isShowingNewMessageView: $isShowingNewMessageView, selectedIndex: $selectedIndex)
                .fullScreenCover(isPresented: $isShowingNewQuestion) {
                    NewQuestionView(isPresented: $isShowingNewQuestion, questionUploaded: $questionUploaded)
                }
                .navigationBarTitleDisplayMode(.inline)
                .tag(5)
            QuestionAnswerSearchView(showSidebar: $showSidebar, questionUploaded: $questionUploaded, isShowingNewQuestion: $isShowingNewQuestion, isShowingNewMessageView: $isShowingNewMessageView, selectedIndex: $selectedIndex)
                .navigationBarTitleDisplayMode(.inline)
                .tag(6)
            NotificationView(showSidebar: $showSidebar, isShowingNewTweetView: $isShowingNewTweetView, isShowingNewMessageView: $isShowingNewMessageView, isShowingNewQuestion: $isShowingNewQuestion, selectedIndex: $selectedIndex, pageInfo: "question")
                .navigationBarTitleDisplayMode(.inline)
                .tag(8)
            ConversationsView(showSidebar: $showSidebar, isShowingNewMessageView: $isShowingNewMessageView, isShowingNewTweetView: $isShowingNewTweetView, isShowingNewQuestion: $isShowingNewQuestion, selectedIndex: $selectedIndex, showChat: $showChat, user: $user, pageInfo: "question")
                .sheet(isPresented: $isShowingNewMessageView, content: {
                    NewMessageView(show: $isShowingNewMessageView, startChat: $showChat, user: $user)
                })
                .navigationBarTitleDisplayMode(.inline)
                .tag(9)
        }
    }
}
