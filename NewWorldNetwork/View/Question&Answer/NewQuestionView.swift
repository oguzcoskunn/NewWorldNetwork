//
//  NewQuestionView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 28.09.2021.
//


import SwiftUI
import ToastSwiftUI

struct NewQuestionView: View {
    @State private var captionToast: Bool = false
    @State private var loadingToast: Bool = false
    
    @Binding var isPresented: Bool
    
    @State var captionText: String = ""
    @State var titleText: String = ""
    @State var gameNameText: String = ""
    
    @Binding var questionUploaded: Bool
    @ObservedObject var viewModel: UploadQuestionViewModel
    @State var selectedUIImage: UIImage?
    
    init(isPresented: Binding<Bool>, questionUploaded: Binding<Bool>) {
        self._isPresented = isPresented
        self._questionUploaded = questionUploaded
        self.viewModel = UploadQuestionViewModel(isPresented: isPresented, questionUploaded: questionUploaded)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Color("NWbackground")
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment : .leading) {
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
                        VStack(alignment: .leading, spacing: 20) {
                            TextField("", text: $gameNameText)
                                .placeholder(when: gameNameText.isEmpty, alignment: .leading) {
                                    Text("Game Name")
                                        .foregroundColor(.black)
                                }
                                .font(.system(size: 16))
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 15)
                                .foregroundColor(.black)
                                .frame(width: UIScreen.main.bounds.width * 0.5, height: 40)
                                .background(Color("NWgray"))
                                .clipped()
                                .cornerRadius(15)
                            TextField("", text: $titleText)
                                .placeholder(when: titleText.isEmpty, alignment: .leading) {
                                    Text("Title")
                                        .foregroundColor(.black)
                                }
                                .font(.system(size: 18, weight: .semibold))
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 15)
                                .foregroundColor(.black)
                                .frame(width: UIScreen.main.bounds.width * 0.75, height: 40)
                                .background(Color("NWgray"))
                                .clipped()
                                .cornerRadius(15)
                            NewQuestionTextArea("Your question here", text: $captionText, selectedUIImage: $selectedUIImage)
                                
                        }
                        
                    }
                }.padding(.horizontal, 15)
            }
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
                        if !captionText.isEmpty && !gameNameText.isEmpty && !titleText.isEmpty {
                            if let currentImage = selectedUIImage {
                                viewModel.uploadQuestionWithImage(title: titleText, caption: captionText, gameName: gameNameText, selectedImage: currentImage)
                            } else {
                                viewModel.uploadQuestion(title: titleText, caption: captionText, gameName: gameNameText)
                            }
                        } else {
                            self.captionToast.toggle()
                        }
                       
                        
                    }, label: {
                        Text("Send Question")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color("NWorange"))
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    })
            )
        }
        .onChange(of: self.viewModel.loadingNow, perform: { value in
            self.loadingToast = value
        })
        .toast(isPresenting: $loadingToast, message: "Loading", icon: .loading, backgroundColor: Color("NWgray"), autoDismiss: .after(5))
        .toast(isPresenting: $captionToast, message: "All areas must be filled!", icon: .error, backgroundColor: Color("NWgray"), autoDismiss: .after(3))
    }
}



