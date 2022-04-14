//
//  TextArea.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 23.08.2021.
//

import SwiftUI

struct TextArea: View {
    @Binding var text: String
    @Binding var selectedUIImage: UIImage?
    
    @State var showImagePicker = false
    @State var image: Image?
    
    let placeholder: String
    
    init(_ placeholder: String, text: Binding<String>, selectedUIImage: Binding<UIImage?>) {
        self._text = text
        self._selectedUIImage = selectedUIImage
        self.placeholder = placeholder
        UITextView.appearance().backgroundColor = .clear
        //UITableView.appearance().backgroundColor = UIColor(Color("NWbackground"))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ZStack(alignment: .topLeading) {
                    Text(text.isEmpty ? placeholder : "")
                        .foregroundColor(Color("NWgray"))
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 3)
                    TextEditor(text: $text)
                        .foregroundColor(Color(.white))
                        .multilineTextAlignment(.leading)
                }
                .font(.body)
                ImageView(showImagePicker: $showImagePicker, selectedUIImage: $selectedUIImage, image: $image, colorName: "NWgray", width: UIScreen.main.bounds.width * 0.7)
            }
        }
        .background(Color("NWbackground"))
        .padding(.vertical, 1)
        .padding(.horizontal, 1)
    }
}
