//
//  ReplyCell.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 8.09.2021.
//

import SwiftUI
import ToastSwiftUI

struct ReplyCell: View {
    let reply: Reply
    let user: User
    let tweetID: String
    @ObservedObject var replyViewModel: ReplyViewModel
    @ObservedObject var viewModel = ReplyOptionsViewModel()
    @State private var isPresented = false
    @State var reportToast: Bool = false
    @State var reportandBlockToast: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(reply.fullname)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Text("@\(reply.username) .")
                    .foregroundColor(Color("NWgray"))
                Text(reply.timestampString)
                    .foregroundColor(Color("NWgray"))
                Spacer()
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color("NWgray"))
                        .rotationEffect(.degrees(-90))
                }
                .sheet(isPresented: $isPresented, content: {
                    ReplyOptions(reply: reply, tweetID: tweetID, reportToast: $reportToast, reportandBlockToast: $reportandBlockToast, isPresented: $isPresented, replyViewModel: replyViewModel, viewModel: viewModel)
                        .background(Color("NWtoolbar"))
                        .edgesIgnoringSafeArea(.all)
                })
                
            }
            
            if !reply.caption.isEmpty {
                Text(reply.caption)
                    .foregroundColor(.white)
            }
            
            if !reply.imageUrl.isEmpty {
                NavigationLink(
                    destination: ImageFullScreenView(imageUrl: reply.imageUrl),
                    label: {
                        AsyncImage(
                            url: URL(string: reply.imageUrl)!,
                            placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                            image: { Image(uiImage: $0).resizable()}
                        )
                            .scaledToFit()
                            .clipped()
                            .cornerRadius(20)
                            .padding(.top, 5)
                            .frame(maxHeight: UIScreen.main.bounds.height * 0.3)
                    }).buttonStyle(FlatLinkStyle())
            }
        }
        .toast(isPresenting: $reportToast, message: "User reported!", icon: .success, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
        .onChange(of: self.viewModel.replyDeleted, perform: { newValue in
            if newValue {
                self.replyViewModel.refreshReplies = true
                self.viewModel.replyDeleted = false
            }
        })
        .toast(isPresenting: $reportandBlockToast, message: "User blocked and reported!", icon: .success, backgroundColor: Color("NWgray"), autoDismiss: .after(2))
        .onChange(of: reportandBlockToast) { newValue in
            if !newValue {
                AuthViewModel.shared.getBlockedUsers()
                self.replyViewModel.refreshReplies = true
            }
        }
    }
}
