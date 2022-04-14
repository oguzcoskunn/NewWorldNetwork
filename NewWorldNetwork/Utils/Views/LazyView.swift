//
//  LazyView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 29.08.2021.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping() -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}

