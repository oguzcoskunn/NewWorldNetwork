//
//  FilterButtonView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 23.08.2021.
//

import SwiftUI

enum TweetFilterOptions: Int, CaseIterable {
    case tweets
//    case replies
    case likes
    
    var title: String {
        switch self {
        
        case .tweets: return "Shares"
//        case .replies: return "Shares & Replies"
        case .likes: return "Likes"
        }
    }
    
}

struct FilterButtonView: View {
    @Binding var selectedOption: TweetFilterOptions
    
    private let underlineWidth = UIScreen.main.bounds.width / CGFloat(TweetFilterOptions.allCases.count)
    
    private var padding: CGFloat {
        let rawValue = CGFloat(selectedOption.rawValue)
        let count = CGFloat(TweetFilterOptions.allCases.count)
        return ((UIScreen.main.bounds.width / count) * rawValue) + 16
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(TweetFilterOptions.allCases, id: \.self) { option in
                    Button(action: {
                        self.selectedOption = option
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
                .animation(.spring(), value: selectedOption)
        }
    }
}

