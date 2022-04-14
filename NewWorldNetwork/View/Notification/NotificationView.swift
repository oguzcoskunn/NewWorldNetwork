//
//  NotificationView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 12.09.2021.
//

import SwiftUI

struct NotificationView: View {
    @Binding var showSidebar: Bool
    
    @ObservedObject var viewModel = NotificationViewModel()
    @State var tweetUploaded = false
    
    // MARK: - For TabBarView
    @Binding var isShowingNewTweetView: Bool
    @Binding var isShowingNewMessageView: Bool
    @Binding var isShowingNewQuestion: Bool
    @Binding var selectedIndex: Int
    let pageInfo: String
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationBarView(showSidebar: $showSidebar, title: "Notifications")
                ScrollView{
                    HStack {
                        LazyVStack(alignment:.leading, spacing: 10) {
                            ForEach(viewModel.notifications) { notification in
                                NotificationCell(notifInfo: notification)
                            }
                        }
                        .padding(.leading, 5)
                        .padding(.vertical, 15)
                        
                        Spacer()
                    }
                }
                .padding(.vertical, 1)
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
                viewModel.setNotificationsReaded()
            }
            .onDisappear {
                viewModel.setNotificationsReaded()
            }
            .navigationBarHidden(true)
            .background(Color("NWtoolbar"))
            .edgesIgnoringSafeArea(.all)
        }
        
    }
}

