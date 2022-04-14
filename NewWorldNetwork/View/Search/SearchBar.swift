//
//  SearchBar.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 14.08.2021.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text : String
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .padding(.horizontal, 24)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                    }
                )
        }
        .padding()
    }
}
