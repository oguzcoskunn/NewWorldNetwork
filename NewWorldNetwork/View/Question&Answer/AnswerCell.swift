//
//  AnswerCell.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 28.09.2021.
//

import SwiftUI
import ToastSwiftUI

struct AnswerCell: View {
    @State var isPresented: Bool = false
    @State var reportandBlockToast: Bool = false
    @State var reportToast = false
    @Binding var answerUploaded: Bool
    let answer: Answer
    let question: Question
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(user.fullname)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Text("@\(user.username) .")
                    .foregroundColor(Color("NWgray"))
                    .font(.system(size: 12))
                Text(answer.timestampString)
                    .foregroundColor(Color("NWgray"))
                    .font(.system(size: 12))
                Spacer()
                
                if #available(iOS 15.0, *) {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color("NWgray"))
                            .rotationEffect(.degrees(-90))
                    }
                    .sheet(isPresented: $isPresented, content: {
                        AnswerOptionsView(answer: answer, question: question, answerUploaded: $answerUploaded, reportToast: $reportToast, reportandBlockToast: $reportandBlockToast, isPresented: $isPresented, paddingTopValue: 40)
                            .background(Color("NWtoolbar"))
                            .edgesIgnoringSafeArea(.all)
                    })
                } else {
                    NavigationLink(
                        destination:
                            AnswerOptionsView(answer: answer, question: question, answerUploaded: $answerUploaded, reportToast: $reportToast, reportandBlockToast: $reportandBlockToast, isPresented: $isPresented, paddingTopValue: 120)
                            .background(Color("NWtoolbar"))
                            .edgesIgnoringSafeArea(.all)
                        ,
                        isActive: $isPresented,
                        label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Color("NWgray"))
                                .rotationEffect(.degrees(-90))
                        })
                }
                
                
                
            }
            
            if !answer.caption.isEmpty {
                Text(answer.caption)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .foregroundColor(Color("NWgray"))
            }
            
            if !answer.imageUrl.isEmpty {
                NavigationLink(
                    destination: ImageFullScreenView(imageUrl: answer.imageUrl),
                    label: {
                        AsyncImage(
                            url: URL(string: answer.imageUrl)!,
                            placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                            image: { Image(uiImage: $0).resizable()}
                        )
                            .scaledToFit()
                            .clipped()
                            .cornerRadius(20)
                            .padding(.top, 5)
                            .frame(maxHeight: UIScreen.main.bounds.height * 0.2)
                    }).buttonStyle(FlatLinkStyle())
            }
        }
        .toast(isPresenting: $reportToast, message: "User Reported!", icon: .success, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
        .toast(isPresenting: $reportandBlockToast, message: "User blocked and reported!", icon: .success, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
        .onChange(of: reportandBlockToast) { newValue in
            if !newValue {
                AuthViewModel.shared.getBlockedUsers()
                self.answerUploaded.toggle()
            }
        }
    }
}
