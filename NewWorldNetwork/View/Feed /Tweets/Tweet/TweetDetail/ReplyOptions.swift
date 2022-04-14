//
//  ReplyOptions.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 2.10.2021.
//

import SwiftUI

struct ReplyOptions: View {
    @State private var showBlockAlert: Bool = false
    let reply: Reply
    let tweetID: String
    @Binding var isPresented: Bool
    @Binding var reportToast: Bool
    @Binding var reportandBlockToast: Bool
    @ObservedObject var replyViewModel: ReplyViewModel
    @ObservedObject var viewModel: ReplyOptionsViewModel
    @ObservedObject var reportViewModel = ReportViewModel()
    
    init(reply: Reply, tweetID: String, reportToast: Binding<Bool>, reportandBlockToast: Binding<Bool>, isPresented: Binding<Bool>, replyViewModel: ReplyViewModel, viewModel: ReplyOptionsViewModel) {
        self.reply = reply
        self.tweetID = tweetID
        self._reportToast = reportToast
        self._reportandBlockToast = reportandBlockToast
        self._isPresented = isPresented
        self.replyViewModel = replyViewModel
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            if AuthViewModel.shared.userSession?.uid != reply.uid {
                HStack {
                    Button {
                        showBlockAlert.toggle()
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "flag.fill")
                            Text("Report the User")
                        }
                        .font(.system(size: 18))
                    }
                    Spacer()
                }
                .alert(isPresented:$showBlockAlert) {
                            Alert(
                                title: Text("Do you also want to block this user?"),
                                message: Text("If you block this user you will not be able to see their content."),
                                primaryButton: .destructive(Text("Report & Block User")) {
                                    reportViewModel.reportTheContentandBlockUser(contentID: self.reply.id, contentOwner: self.reply.uid, type: "reply")
                                    self.reportandBlockToast.toggle()
                                    isPresented.toggle()
                                },
                                secondaryButton: .cancel(Text("Report User")) {
                                    reportViewModel.reportTheContent(contentID: self.reply.id, contentOwner: self.reply.uid, type: "reply")
                                    self.reportToast.toggle()
                                    isPresented.toggle()
                                }
                            )
                        }
            }
            
            if AuthViewModel.shared.userSession?.uid == reply.uid {
                HStack {
                    Button {
                        viewModel.deleteReply(reply: reply, tweetId: tweetID)
                        isPresented.toggle()
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "multiply.circle")
                            Text("Delete the Reply")
                        }
                        .font(.system(size: 18))
                    }
                    Spacer()
                }
                
            }
            
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.vertical, 5)
        .padding(.horizontal, 25)
        .padding(.top, 40)
    }
}
