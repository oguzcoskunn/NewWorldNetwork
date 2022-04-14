//
//  SearchView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 14.08.2021.
//

import SwiftUI

struct SearchView: View {
    @State var isProfileViewActive: Bool = false
    @Binding var user: User?
    @Binding var showSidebar: Bool
    
    @State var searchText = ""
    @State var uploadedTweet = false
    @ObservedObject var viewModel = SearchViewModel(config: .search)
    
    // MARK: - For TabBarView
    @Binding var isShowingNewTweetView: Bool
    @Binding var isShowingNewMessageView: Bool
    @Binding var selectedIndex: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                if let user = user {
                    NavigationLink(
                        destination: LazyView(UserProfileView(user: user, isActive: $isProfileViewActive)),
                        isActive: $isProfileViewActive,
                        label: {})
                }
                VStack {
                    NavigationBarView(showSidebar: $showSidebar, title: "Search")
                    ScrollView {
                            SearchBar(text: $searchText)
                            .padding(.horizontal)
                            .padding(.top, 10)
                            
                            VStack(alignment: .leading) {
                                if (!searchText.isEmpty && viewModel.filteredUsers(searchText).isEmpty) || (viewModel.users.isEmpty)  {
                                    Text("No Result...")
                                        .foregroundColor(Color("NWgray"))
                                        .padding(.top, 10)
                                }
                                
                                ForEach(searchText.isEmpty ? viewModel.users : viewModel.filteredUsers(searchText)) { user in
                                    if user.id != "mCJlIwtHQHRb6zPIBcfLTWX9vdY2" {
                                        HStack { Spacer() }
                                        Button {
                                            self.user = user
                                            self.isProfileViewActive.toggle()
                                             } label: {
                                                 UserCell(user: user)
                                             }
                                    }
                                }
                            }
                            .padding(.leading)
                            .padding(.bottom, 10)
                        }
                        .padding(.vertical, 1)
                    .background(Color("NWbackground").scaledToFill())
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarTitle("")
                    TabBarView(isShowingNewTweetView: $isShowingNewTweetView, isShowingNewMessageView: $isShowingNewMessageView, selectedIndex: $selectedIndex)
                }
                .background(Color("NWtoolbar"))
            .edgesIgnoringSafeArea(.all)
            }.navigationBarHidden(true)
        }
        
    }
}
