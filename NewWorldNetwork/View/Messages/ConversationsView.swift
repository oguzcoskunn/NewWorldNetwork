//
//  ConversationsView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 15.08.2021.
//

import SwiftUI

struct ConversationsView: View {
    @Binding var showSidebar: Bool
    
    @Binding var showChat: Bool
    @Binding var user: User?
    @ObservedObject var viewModel = ConversationsViewModel()
    @ObservedObject var notifViewModel = NotificationViewModel()
    
    // MARK: - For TabBarView
    @Binding var isShowingNewTweetView: Bool
    @Binding var isShowingNewMessageView: Bool
    @Binding var isShowingNewQuestion: Bool
    @Binding var selectedIndex: Int
    let pageInfo: String
    
    init(showSidebar: Binding<Bool> ,isShowingNewMessageView: Binding<Bool>, isShowingNewTweetView: Binding<Bool>, isShowingNewQuestion: Binding<Bool>, selectedIndex: Binding<Int>, showChat: Binding<Bool>,user: Binding<User?>, pageInfo: String) {
        self._showSidebar = showSidebar
        self._isShowingNewMessageView = isShowingNewMessageView
        self._isShowingNewTweetView = isShowingNewTweetView
        self._isShowingNewQuestion = isShowingNewQuestion
        self._selectedIndex = selectedIndex
        self._showChat = showChat
        self._user = user
        self.pageInfo = pageInfo
    }
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationBarView(showSidebar: $showSidebar, title: "Messages")
                ZStack(alignment: .bottomTrailing, content: {
                    if let user = user {
                        NavigationLink(
                            destination: LazyView(ChatView(user: user).navigationBarHidden(true)),
                            isActive: $showChat,
                            label: {})
                    }
                    
                    ScrollView {
                        VStack {
                            ForEach(viewModel.recentMessages) { message in
                                Button(action: {
                                    self.user = message.user
                                    self.showChat.toggle()
                                }, label: {
                                    ConversationCell(message: message)
                                })
                            }
                        }
                        .padding(.top, 20)
                    }
                    .padding(.vertical,1)
                    .padding(.horizontal, 14)
                })
                .background(Color("NWbackground").scaledToFill())
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("")

                if pageInfo == "social" {
                    TabBarView(isShowingNewTweetView: $isShowingNewTweetView, isShowingNewMessageView: $isShowingNewMessageView, selectedIndex: $selectedIndex)
                } else {
                    QuestionAnswerTabView(isShowingNewQuestion: $isShowingNewQuestion, isShowingNewMessageView: $isShowingNewMessageView, selectedIndex: $selectedIndex)
                }
            }
            .onAppear {
                notifViewModel.setMessagesReaded()
            }
            .onDisappear {
                notifViewModel.setMessagesReaded()
            }
            .navigationBarHidden(true)
            .background(Color("NWtoolbar"))
            .edgesIgnoringSafeArea(.all)
        }
    }
}
