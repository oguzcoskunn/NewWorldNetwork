//
//  FollorStatsFilterButtonView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 27.09.2021.
//

import SwiftUI

enum FollowStatsFilterOption: Int, CaseIterable {
    case followers
    case following
    
    var title: String {
        switch self {
        
        case .followers: return "Followers"
        case .following: return "Following"
        }
    }
    
}

struct FollowStatsFilterButtonView: View {
    @Binding var selectedStatFilter: FollowStatsFilterOption
    
    
    private let underlineWidth = UIScreen.main.bounds.width / CGFloat(FollowStatsFilterOption.allCases.count)
    
    private var padding: CGFloat {
        let rawValue = CGFloat(selectedStatFilter.rawValue)
        let count = CGFloat(FollowStatsFilterOption.allCases.count)
        return ((UIScreen.main.bounds.width / count) * rawValue) + 16
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(FollowStatsFilterOption.allCases, id: \.self) { option in
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
