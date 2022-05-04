//
//  MainTabView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 14.09.2021.
//

import SwiftUI

struct MainTabView: View { 
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
            FeedView(showSidebar: $showSidebar, newTweetUploaded: $newTweetUploaded, isShowingNewTweetView: $isShowingNewTweetView, isShowingNewMessageView: $isShowingNewMessageView, selectedIndex: $selectedIndex)
                .navigationBarTitleDisplayMode(.inline)
                .fullScreenCover(isPresented: $isShowingNewTweetView) {
                    NewTweetView(isPresented: $isShowingNewTweetView, tweetUploaded: $newTweetUploaded)
                }
                .tag(0)
            SearchView(user: $user, showSidebar: $showSidebar, isShowingNewTweetView: $isShowingNewTweetView, isShowingNewMessageView: $isShowingNewMessageView, selectedIndex: $selectedIndex)
                .navigationBarTitleDisplayMode(.inline)
                .tag(1)
            NotificationView(showSidebar: $showSidebar, isShowingNewTweetView: $isShowingNewTweetView, isShowingNewMessageView: $isShowingNewMessageView, isShowingNewQuestion: $isShowingNewQuestion, selectedIndex: $selectedIndex, pageInfo: "social")
                .navigationBarTitleDisplayMode(.inline)
                .tag(3)
            ConversationsView(showSidebar: $showSidebar, isShowingNewMessageView: $isShowingNewMessageView, isShowingNewTweetView: $isShowingNewTweetView, isShowingNewQuestion: $isShowingNewQuestion, selectedIndex: $selectedIndex, showChat: $showChat, user: $user, pageInfo: "social")
                .sheet(isPresented: $isShowingNewMessageView, content: {
                    NewMessageView(show: $isShowingNewMessageView, startChat: $showChat, user: $user)
                })
                .navigationBarTitleDisplayMode(.inline)
                .tag(4)
        }
        
//        switch selectedIndex {
//        case 0:
//            FeedView(showSidebar: $showSidebar, newTweetUploaded: $newTweetUploaded, isShowingNewTweetView: $isShowingNewTweetView, isShowingNewMessageView: $isShowingNewMessageView, selectedIndex: $selectedIndex)
//                .fullScreenCover(isPresented: $isShowingNewTweetView) {
//                    NewTweetView(isPresented: $isShowingNewTweetView, tweetUploaded: $newTweetUploaded)
//                }
//        case 1:
//            SearchView(user: $user, showSidebar: $showSidebar, isShowingNewTweetView: $isShowingNewTweetView, isShowingNewMessageView: $isShowingNewMessageView, selectedIndex: $selectedIndex)
//        case 3:
//            NotificationView(showSidebar: $showSidebar, isShowingNewTweetView: $isShowingNewTweetView, isShowingNewMessageView: $isShowingNewMessageView, isShowingNewQuestion: $isShowingNewQuestion, selectedIndex: $selectedIndex, pageInfo: "social")
//
//        case 4:
//            ConversationsView(showSidebar: $showSidebar, isShowingNewMessageView: $isShowingNewMessageView, isShowingNewTweetView: $isShowingNewTweetView, isShowingNewQuestion: $isShowingNewQuestion, selectedIndex: $selectedIndex, showChat: $showChat, user: $user, pageInfo: "social")
//                .sheet(isPresented: $isShowingNewMessageView, content: {
//                    NewMessageView(show: $isShowingNewMessageView, startChat: $showChat, user: $user)
//                })
//        case 5:
//            QuestionAnswerView(showSidebar: $showSidebar, questionUploaded: $questionUploaded, isShowingNewQuestion: $isShowingNewQuestion, isShowingNewMessageView: $isShowingNewMessageView, selectedIndex: $selectedIndex)
//                .fullScreenCover(isPresented: $isShowingNewQuestion) {
//                    NewQuestionView(isPresented: $isShowingNewQuestion, questionUploaded: $questionUploaded)
//                }
//        case 6:
//            QuestionAnswerSearchView(showSidebar: $showSidebar, questionUploaded: $questionUploaded, isShowingNewQuestion: $isShowingNewQuestion, isShowingNewMessageView: $isShowingNewMessageView, selectedIndex: $selectedIndex)
//        case 8:
//            NotificationView(showSidebar: $showSidebar, isShowingNewTweetView: $isShowingNewTweetView, isShowingNewMessageView: $isShowingNewMessageView, isShowingNewQuestion: $isShowingNewQuestion, selectedIndex: $selectedIndex, pageInfo: "question")
//
//        case 9:
//            ConversationsView(showSidebar: $showSidebar, isShowingNewMessageView: $isShowingNewMessageView, isShowingNewTweetView: $isShowingNewTweetView, isShowingNewQuestion: $isShowingNewQuestion, selectedIndex: $selectedIndex, showChat: $showChat, user: $user, pageInfo: "question")
//                .sheet(isPresented: $isShowingNewMessageView, content: {
//                    NewMessageView(show: $isShowingNewMessageView, startChat: $showChat, user: $user)
//                })
//        default:
//            NavigationView {
//                Text("Page Not Found")
//
//            }
//        }
    }
}


