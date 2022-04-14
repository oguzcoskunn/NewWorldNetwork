//
//  ImageLoadFailed.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 21.09.2021.
//

import SwiftUI

struct ImageLoadFailed: View {
    let error: Error
    var body: some View {
        Text("\(error.localizedDescription)")
    }
}
