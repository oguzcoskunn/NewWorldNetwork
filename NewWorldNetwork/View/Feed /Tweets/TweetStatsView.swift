//
//  TweetStats.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 25.09.2021.
//

import SwiftUI

struct TweetStatsView: View {
    let tweet: Tweet
    @Binding var user: User
    @Binding var showRepliesView: Bool
    @Binding var showLikesView: Bool
    @Binding var showProfile: Bool
    
    @Binding var selectedFilter: TweetStatsFilterOptions
    @ObservedObject var viewModel: TweetStatsViewModel
    
    init(tweet: Tweet, showRepliesView: Binding<Bool>, showLikesView: Binding<Bool>, showProfile: Binding<Bool>, user: Binding<User>, selectedFilter: Binding<TweetStatsFilterOptions>) {
        self.tweet = tweet
        self.viewModel = TweetStatsViewModel(tweet: tweet)
        self._user = user
        self._showRepliesView = showRepliesView
        self._showLikesView = showLikesView
        self._showProfile = showProfile
        self._selectedFilter = selectedFilter
    }
    
    var body: some View {
        ScrollView {
            TweetStatsFilterButtonView(selectedStatFilter: $selectedFilter)
                .padding()
            VStack(alignment: .leading) {
                ForEach(viewModel.stats(forFilter: selectedFilter)) { user in
                    HStack { Spacer() }
                    Button(action: {
                        self.user = user
                        self.showRepliesView = false
                        self.showLikesView = false
                        self.showProfile.toggle()
                    }, label: {
                        UserCell(user: user)
                    })
                }
            }
            .padding(.leading, 30)
        }
        .background(Color("NWtoolbar"))
        .edgesIgnoringSafeArea(.all)
    }
}
