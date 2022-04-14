//
//  CustomSecureField.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 23.08.2021.
//

import SwiftUI

struct CustomSecureField: View {
    @Binding var text: String
    let placeholder: Text
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .foregroundColor(Color(.init(white: 1, alpha: 0.87)))
                    .padding(.leading, 40)
            }
            
            HStack(spacing: 16) {
                Image(systemName: "lock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.white)
                
                SecureField("", text: $text)
            }
        }
    }
}

