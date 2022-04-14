//
//  NewMessageView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 15.08.2021.
//

import SwiftUI

struct NewMessageView: View {
    @State var searchText = ""
    @Binding var show : Bool
    @Binding var startChat : Bool
    @Binding var user: User?
    @ObservedObject var viewModel = SearchViewModel(config: .newMessage)
    
    var body: some View {
        ScrollView {
            SearchBar(text: $searchText)
                .padding()
            
            VStack(alignment: .leading) {
                if (!searchText.isEmpty && viewModel.filteredUsers(searchText).isEmpty) || (viewModel.users.isEmpty) {
                    Text("No Result...")
                        .foregroundColor(Color("NWgray"))
                        .padding(.top, 10)
                }
                ForEach(searchText.isEmpty ? viewModel.users : viewModel.filteredUsers(searchText)) { user in
                    if user.id != "mCJlIwtHQHRb6zPIBcfLTWX9vdY2" {
                        HStack { Spacer() }
                        Button(action: {
                            self.show.toggle()
                            self.startChat.toggle()
                            self.user = user
                        }, label: {
                            UserCell(user: user)
                        })
                    }
                }
            }
            .padding(.leading)
        }
        .background(Color("NWbackground").scaledToFill())
        .ignoresSafeArea()
    }
}
