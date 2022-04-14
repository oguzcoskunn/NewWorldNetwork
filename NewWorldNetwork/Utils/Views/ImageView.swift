//
//  ImageView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 15.09.2021.
//

import SwiftUI

struct ImageView: View {
    @Binding var showImagePicker: Bool
    @Binding var selectedUIImage: UIImage?
    @Binding var image: Image?
    let colorName: String
    let width: CGFloat
    
    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        image = Image(uiImage: selectedImage)
    }
    
    var body: some View {
        if let image = image {
            ZStack(alignment: .topTrailing, content: {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: width)
                    .clipped()
                    .cornerRadius(width/15)
                Button {
                    self.image = nil
                    self.selectedUIImage = nil
                } label: {
                    Image(systemName: "multiply")
                        .foregroundColor(Color(.black))
                        .scaledToFill()
                        .frame(width: 25, height: 25)
                        .background(Color("NWorange"))
                        .clipped()
                        .cornerRadius(56 / 2)
                        .padding(7)
                }
            })
        } else  {
            Button(action: {showImagePicker.toggle()}, label: {
                Image(systemName: "photo.fill")
                    .foregroundColor(Color(colorName))
            }).buttonStyle(FlatLinkStyle())
            .padding(.vertical, 10)
            .padding(.horizontal, 4)
            .fullScreenCover(isPresented: $showImagePicker, onDismiss: loadImage, content: {
                ImagePicker(image: $selectedUIImage)
            })
        }
    }
}
