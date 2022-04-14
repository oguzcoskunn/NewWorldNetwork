//
//  SendBugTextArea.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 29.09.2021.
//

import SwiftUI
import ToastSwiftUI

struct SendBugTextArea: View {
    @State private var titleError: Bool = false
    @State private var captionError: Bool = false
    
    @Binding var sendBugToast : Bool
    @Binding var bugReportSent: Bool
    @Binding var text: String
    @Binding var selectedUIImage: UIImage?
    @Binding var titleText: String
    
    @State var showImagePicker = false
    @State var image: Image?
    
    let placeholder: String
    
    @ObservedObject var viewModel: UploadBugReportViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(_ placeholder: String, text: Binding<String>, selectedUIImage: Binding<UIImage?>, titleText: Binding<String>, bugReportSent: Binding<Bool>, sendBugToast: Binding<Bool>) {
        self._text = text
        self._selectedUIImage = selectedUIImage
        self._titleText = titleText
        self.placeholder = placeholder
        UITextView.appearance().backgroundColor = .clear
        self._bugReportSent = bugReportSent
        self._sendBugToast = sendBugToast
        self.viewModel = UploadBugReportViewModel(bugReportSent: bugReportSent)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 30) {
                VStack(alignment: .center, spacing: 20) {
                    TextField("", text: $titleText)
                        .placeholder(when: titleText.isEmpty, alignment: .leading) {
                            Text("Title")
                                .foregroundColor(.black)
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 15)
                        .foregroundColor(.black)
                        .frame(height: 30)
                        .background(Color("NWgray"))
                        .clipped()
                        .cornerRadius(15)
                }
                VStack(alignment: .leading) {
                    ZStack(alignment: .topLeading) {
                        Text(text.isEmpty ? placeholder : "")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 3)
                        TextEditor(text: $text)
                            .foregroundColor(Color(.black))
                            .multilineTextAlignment(.leading)
                    }
                    .font(.body)
                    ImageView(showImagePicker: $showImagePicker, selectedUIImage: $selectedUIImage, image: $image, colorName: "black", width: UIScreen.main.bounds.width * 0.5)
                }
                .padding()
                .background(Color("NWgray"))
                .clipped()
                .cornerRadius(15)
                
                
                Button(action: {
                    if !text.isEmpty && !titleText.isEmpty {
                        DispatchQueue.global().async {
                            if let currentImage = selectedUIImage {
                                viewModel.sendBugReportWithImage(title: titleText, caption: text, selectedImage: currentImage)
                            } else {
                                viewModel.sendBugReport(title: titleText, caption: text)
                            }
                        }
                        self.presentationMode.wrappedValue.dismiss()
                        self.sendBugToast.toggle()
                    } else {
                        if titleText.isEmpty {
                            self.titleError.toggle()
                        } else {
                            self.captionError.toggle()
                        }
                    }
                    
                }, label: {
                    Text("Send Bug Report")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color("NWorange"))
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                })
            }
        }
        
        .background(Color("NWbackground"))
        .padding(.vertical, 1)
        .padding(.horizontal, 1)
        .toast(isPresenting: $titleError, message: "Enter Title!", icon: .error, backgroundColor: Color("NWgray"), autoDismiss: .after(3))
        .toast(isPresenting: $captionError, message: "Enter Text!", icon: .error, backgroundColor: Color("NWgray"), autoDismiss: .after(3))
    }
}
