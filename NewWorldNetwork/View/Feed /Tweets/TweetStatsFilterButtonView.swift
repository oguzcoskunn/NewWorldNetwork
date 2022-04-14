//
//  TweetStatsFilterButtonView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 25.09.2021.
//


import SwiftUI

enum TweetStatsFilterOptions: Int, CaseIterable {
    case comments
    case likes
    
    var title: String {
        switch self {
        
        case .comments: return "Comments"
        case .likes: return "Likes"
        }
    }
    
}

struct TweetStatsFilterButtonView: View {
    @Binding var selectedStatFilter: TweetStatsFilterOptions
    
    
    private let underlineWidth = UIScreen.main.bounds.width / CGFloat(TweetStatsFilterOptions.allCases.count)
    
    private var padding: CGFloat {
        let rawValue = CGFloat(selectedStatFilter.rawValue)
        let count = CGFloat(TweetStatsFilterOptions.allCases.count)
        return ((UIScreen.main.bounds.width / count) * rawValue) + 16
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(TweetStatsFilterOptions.allCases, id: \.self) { option in
                    Button(action: {
                        self.selectedStatFilter = option
                    }, label: {
                        Text(option.title)
                            .frame(width: underlineWidth)
                            .foregroundColor(Color(.white))
                    })
                }
            }
            
            Rectangle()
                .frame(width: underlineWidth - 32, height: 3, alignment: .center)
                .foregroundColor(Color("NWorange"))
                .padding(.leading, padding)
                .animation(.spring(), value: selectedStatFilter)
        }
    }
}
