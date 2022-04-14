//
//  ImageFullScreenView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 16.09.2021.
//

import SwiftUI

struct ImageFullScreenView: View {
    let imageUrl: String
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Color("NWbackground")
                AsyncImage(
                    url: URL(string: imageUrl)!,
                    placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                    image: { Image(uiImage: $0).resizable()}
                )
                    .aspectRatio(contentMode: .fit)
                    .pinchToZoom()
            }
        }.edgesIgnoringSafeArea(.all)        
    }
}

