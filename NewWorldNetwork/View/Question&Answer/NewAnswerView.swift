//
//  NewAnswerViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 28.09.2021.
//

import SwiftUI
import ToastSwiftUI

struct NewAnswerView: View {
    @State private var captionToast: Bool = false
    @State private var loadingToast: Bool = false
    
    let question: Question
    @Binding var isPresented: Bool
    @Binding var answerUploaded: Bool
    @State var captionText: String = ""
    @ObservedObject var viewModel: UploadAnswerViewModel
    @State var selectedUIImage: UIImage?

    init(question: Question ,isPresented: Binding<Bool> , answerUploaded: Binding<Bool>) {
        self.question = question
        self._isPresented = isPresented
        self._answerUploaded = answerUploaded
        self.viewModel = UploadAnswerViewModel(question: question, isPresented: isPresented, answerUploaded: answerUploaded)
    }

    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 20) {
                    HStack(spacing: 1) {
                        Text("Answering to ")
                            .foregroundColor(Color("NWgray"))
                        Text("@\(question.username)")
                            .fontWeight(.bold)
                            .foregroundColor(Color("NWorange"))
                        Spacer()
                    }
                    .font(.system(size: 16))
                    Divider()
                    HStack(alignment: .top) {
                        if let user = AuthViewModel.shared.user {
                            AsyncImage(
                                url: URL(string: user.profileImageUrl)!,
                                placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                                image: { Image(uiImage: $0).resizable()}
                            )
                                .scaledToFill()
                                .clipped()
                                .frame(width: 64, height: 64)
                                .cornerRadius(32)
                        }
                        TextArea("Answer the question", text: $captionText, selectedUIImage: $selectedUIImage)
                        Spacer()
                    }
                }

                .padding(.top, 100)
                .navigationBarItems(
                    leading:
                        Button(action: { isPresented.toggle() }, label: {
                            Image(systemName: "multiply")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 15, height: 15)
                                .foregroundColor(Color("NWorange"))
                        }),

                    trailing:
                        Button(action: {
                            self.viewModel.loadingNow = true
                            if let currentImage = selectedUIImage {
                                viewModel.answerQuestionWithImage(caption: captionText, selectedImage: currentImage)
                            } else {
                                if !captionText.isEmpty {
                                    viewModel.answerQuestion(caption: captionText)
                                } else {
                                    self.captionToast.toggle()
                                }
                            }
                        }, label: {
                            Text("Send Answer")
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color("NWorange"))
                                .foregroundColor(.black)
                                .clipShape(Capsule())
                        })
            )
                Spacer()
            }
            .padding()
            .background(Color("NWbackground").scaledToFill())
            .ignoresSafeArea()
        }
        .onChange(of: self.viewModel.loadingNow, perform: { value in
            self.loadingToast = value
        })
        .toast(isPresenting: $loadingToast, message: "Loading", icon: .loading, backgroundColor: Color("NWgray"), autoDismiss: .after(5))
        .toast(isPresenting: $captionToast, message: "Enter Text", icon: .error, backgroundColor: Color("NWgray"), autoDismiss: .after(3))
    }
}
