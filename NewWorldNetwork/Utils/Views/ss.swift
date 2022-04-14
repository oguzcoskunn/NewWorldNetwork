//
//  ss.swift
//  NewWorldSocial
//
//  Created by Oğuz Coşkun on 15.09.2021.
//

import SwiftUI

struct ss: View {
    @State var text: String = "test"

        var body: some View {
            List((1...10), id: \.self) { _ in
                ZStack {
                    TextEditor(text: $text)
                    Text(text).opacity(0).padding(.all, 8) // <- This will solve the issue if it is in the same ZStack
                }
            }
        }
}

struct ss_Previews: PreviewProvider {
    static var previews: some View {
        ss()
    }
}
