//
//  NewQuestionImageView.swift
//  NewWorldSocial
//
//  Created by Oğuz Coşkun on 28.09.2021.
//

import SwiftUI

struct NewQuestionImageView: View {
    @Binding var showImagePicker: Bool
    @Binding var selectedUIImage: UIImage?
    @Binding var image: Image?
    
    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        image = Image(uiImage: selectedImage)
    }
    
    var body: some View {
        if let image = image {
            ZStack(alignment: .topTrailing, content: {
                let width = UIScreen.main.bounds.width * 0.7
                
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
                    .foregroundColor(.black)
            }).buttonStyle(FlatLinkStyle())
            .padding(.vertical, 10)
            .padding(.horizontal, 4)
            .fullScreenCover(isPresented: $showImagePicker, onDismiss: loadImage, content: {
                ImagePicker(image: $selectedUIImage)
            })
        }
    }
}
