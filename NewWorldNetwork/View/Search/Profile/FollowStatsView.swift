//
//  FollowStatsView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 27.09.2021.
//

import SwiftUI

struct FollowStatsView: View {
    let currentUser: User
    @Binding var user: User
    @Binding var showFollowersView: Bool
    @Binding var showFollowingView: Bool
    @Binding var showProfile: Bool
    
    @Binding var selectedFilter: FollowStatsFilterOption
    @ObservedObject var viewModel: FollowStatsViewModel
    
    let paddingTopValue: CGFloat
    
    init(currentUser: User ,showFollowersView: Binding<Bool>, showFollowingView: Binding<Bool>, showProfile: Binding<Bool>, user: Binding<User>, selectedFilter: Binding<FollowStatsFilterOption>, paddingTopValue: CGFloat) {
        self.currentUser = currentUser
        self._user = user
        self._showFollowersView = showFollowersView
        self._showFollowingView = showFollowingView
        self._showProfile = showProfile
        self._selectedFilter = selectedFilter
        self.viewModel = FollowStatsViewModel(user: currentUser)
        self.paddingTopValue = paddingTopValue
    }
    
    var body: some View {
        ScrollView {
            FollowStatsFilterButtonView(selectedStatFilter: $selectedFilter)
                .padding()
            VStack(alignment: .leading) {
                ForEach(viewModel.stats(forFilter: selectedFilter)) { user in
                    HStack { Spacer() }
                    Button(action: {
                        self.user = user
                        self.showFollowersView = false
                        self.showFollowingView = false
                        self.showProfile.toggle()
                    }, label: {
                        UserCell(user: user)
                    })
                }
            }
            .padding(.leading, 30)
        }
        .padding(.top, paddingTopValue)
        .background(Color("NWtoolbar"))
        .edgesIgnoringSafeArea(.all)
    }
}

