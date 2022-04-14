//
//  SendBugView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 29.09.2021.
//

import SwiftUI

struct SendBugView: View {
    @Binding var sendBugToast: Bool
    @State var bugReportSent: Bool = false
    @State var captionText: String = ""
    @State var titleText: String = ""
    
    @State var selectedUIImage: UIImage?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("NWbackground")
                .edgesIgnoringSafeArea(.all)
            SendBugTextArea("Your bug report here...", text: $captionText, selectedUIImage: $selectedUIImage, titleText: $titleText, bugReportSent: $bugReportSent, sendBugToast: $sendBugToast)
                .padding(.horizontal, 15)
        }
    }
}



