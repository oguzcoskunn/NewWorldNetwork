//
//  MessageInputView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 15.08.2021.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct MessageInputView: View {
    @Binding var messageText : String
    
    var action: () -> Void
    
    var body: some View {
        ZStack {
            Color("NWtoolbar")
            HStack {
                TextField("", text: $messageText)
                    .foregroundColor(.white)
                    .placeholder(when: messageText.isEmpty) {
                        Text("Message...").foregroundColor(Color("NWgray"))
                    }
                
                
                Button(action: action , label: {
                    Text("Send")
                        .foregroundColor(Color("NWorange"))
                })
            }
            .padding()
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.06)
            .clipped()
            .cornerRadius(UIScreen.main.bounds.height * 0.06 / 2)
            .padding(.bottom, 25)
            .padding(.horizontal, 10)
        
        
    }
}
