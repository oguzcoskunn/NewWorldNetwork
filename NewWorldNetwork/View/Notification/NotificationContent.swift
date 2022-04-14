//
//  NotificationView.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 12.09.2021.
//

//senderImageUrl: notification.senderProfileImageUrl, senderCommentImageUrl: notification.senderImageUrl, title: notification.senderFullname, content: notification.senderCaption, type: notification.notifyType

import SwiftUI

struct NotificationContent: View {
    let notification: Notification
    let likeCount: Int
    let replyCount: Int
    let answerCount: Int
    
    var body: some View {
        let senderImageUrl = notification.senderProfileImageUrl
        let senderCommentImageUrl = notification.senderImageUrl
        let title = notification.senderFullname
        let content = notification.senderCaption
        let type = notification.notifyType
        let icon = getIcon(notifType: type)
        
        HStack(alignment: .top, spacing: 20) {
            if type == "answer" {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 35, height: 30)
                    .foregroundColor(Color("NWorange"))
                    .padding(.vertical,2)
            } else {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("NWorange"))
                    .padding(.vertical,2)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                
                HStack {
                    AsyncImage(
                        url: URL(string: senderImageUrl)!,
                        placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                        image: { Image(uiImage: $0).resizable()}
                    )
                        .scaledToFill()
                        .clipped()
                        .frame(width: 40, height: 40)
                        .cornerRadius(56 / 2)
                        .padding(.bottom, 4)
                    Spacer()
                    Text(notification.timestampString)
                        .foregroundColor(Color("NWgray"))
                        .font(.system(size: 14))
                }
                
                let action = getAction(notifType: type)
                if likeCount > 0 {
                    Group {
                        Text(title).bold() + Text(" and \(likeCount) other users") + Text(action)
                    }
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.bottom, 3)
                } else if replyCount > 0 {
                    Group {
                        Text(title).bold() + Text(action) + Text("\n+\(replyCount) comment(s)").foregroundColor(Color("NWgray"))
                    }
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.bottom, 3)
                } else if answerCount > 0 {
                    Group {
                        Text(title).bold() + Text(action) + Text("\n+\(answerCount) answer(s)").foregroundColor(Color("NWgray"))
                    }
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.bottom, 3)
                } else {
                    Group {
                        Text(title).bold() + Text(action)
                    }
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                }
                
                
                if !content.isEmpty {
                    Text(content)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 14))
                        .foregroundColor(Color("NWgray"))
                        .lineLimit(2)
                }
                
                if !senderCommentImageUrl.isEmpty {
                    AsyncImage(
                        url: URL(string: senderCommentImageUrl)!,
                        placeholder: { ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color("NWorange"))) },
                        image: { Image(uiImage: $0).resizable()}
                    )
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.2)
                        .clipped()
                        .cornerRadius(10)
                        .padding(.top, 5)
                }
            }
            .padding(.trailing, 10)
        }
        .padding(.horizontal, 10)
    }
    
    func getAction(notifType: String) -> String {
        switch notifType {
        case "reply": return " replied your post:"
        case "answer": return " answered your question:"
        case "follow": return " followed you."
        case "like": return " liked your post:"
        default:
            return "Not found"
        }
    }
    
    func getIcon(notifType: String) -> String {
        switch notifType {
        case "reply": return "text.bubble.fill"
        case "answer": return "person.fill.questionmark"
        case "follow": return "person.fill"
        case "like": return "suit.heart.fill"
        default:
            return "Not found"
        }
    }
}

