//
//  QuestionAnswerSearchBar.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 29.09.2021.
//

import SwiftUI

struct QuestionAnswerSearchBar: View {
    let placerholder: String
    @Binding var text : String
    var body: some View {
        HStack {
            TextField("", text: $text)
                .placeholder(when: text.isEmpty, alignment: .center) {
                    Text(placerholder)
                        .foregroundColor(.black)
                }
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(8)
                .padding(.horizontal, 10)
                .background(Color("NWgray"))
                .clipped()
                .cornerRadius(20)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(.black))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                    }
                )
        }
        .font(.system(size: 14))
        .padding()
    }
}
