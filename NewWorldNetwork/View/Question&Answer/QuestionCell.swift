//
//  QuestionCell.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 28.09.2021.
//

import SwiftUI
import ToastSwiftUI

struct QuestionCell: View {
    let question: Question
    let user: User
    
    @Binding var questionUploaded: Bool
    @State private var isPresented = false
    @State var reportToast = false
    @State var reportandBlockToast: Bool = false
    
    init(question: Question, user: User, questionUploaded: Binding<Bool>) {
        self.question = question
        self.user = user
        self._questionUploaded = questionUploaded
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(question.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                Spacer()
                Text(question.timestampString)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color("NWgray"))
                    .padding(.trailing, 20)
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color("NWgray"))
                        .rotationEffect(.degrees(-90))
                }
                .sheet(isPresented: $isPresented, content: {
                    QuestionOptionsView(question: question, questionUploaded: $questionUploaded, reportToast: $reportToast, reportandBlockToast: $reportandBlockToast, isPresented: $isPresented)
                        .background(Color("NWtoolbar"))
                        .edgesIgnoringSafeArea(.all)
                })
                
            }
            
            if !question.caption.isEmpty {
                Text(question.caption)
                    .foregroundColor(Color("NWgray"))
                    .font(.system(size: 12))
                    .lineLimit(2)
                    .padding(.trailing, 25)
            }
            
            HStack(spacing: 20) {
                HStack(spacing: 5) {
                    Image(systemName: "arrowshape.turn.up.left.fill")
                        .resizable()
                        .frame(width: 12, height: 8)
                    Text("\(question.answers)")
                        .font(.system(size: 12))
                }
                .foregroundColor(Color("NWgray"))
                
                HStack(spacing: 5) {
                    Text("Status:")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color("NWgray"))
                    if question.status == 1 {
                        Image(systemName: "checkmark.seal.fill")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color("NWorange"))
                    } else {
                        Image(systemName: "checkmark.seal")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color("NWgray"))
                    }
                }
                
                HStack(alignment: .center, spacing: 5) {
                    Text("Game:")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color("NWgray"))
                    Text("\(question.gameName)")
                        .font(.system(size: 12))
                        .padding(.horizontal, 5)
                        .foregroundColor(.black)
                        .background(Color("NWgray"))
                        .clipped()
                        .cornerRadius(15)
                }
                
            }
            
        }
        .toast(isPresenting: $reportToast, message: "User reported!", icon: .success, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
        .toast(isPresenting: $reportandBlockToast, message: "User blocked and reported!", icon: .success, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
        .onChange(of: reportandBlockToast) { newValue in
            if !newValue {
                AuthViewModel.shared.getBlockedUsers()
                self.questionUploaded.toggle()
            }
        }
        
    }
}
