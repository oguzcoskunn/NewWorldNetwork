//
//  ChatViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 29.08.2021.
//

import SwiftUI
import Firebase
import OneSignal

class ChatViewModel: ObservableObject {
    let user: User
    @Published var messages = [Message]()
    @Published var showChatAd: Bool = false
    
    init(user: User) {
        self.user = user
        fetchMessages()
    }
    
    func fetchMessages() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(uid).collection(user.id)
//        query.order(by: "timestamp", descending: false)
        
        query.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            
            changes.forEach { change in
                let messageData = change.document.data()
                guard let fromId = messageData["fromId"] as? String else { return }
                
                COLLECTION_USERS.document(fromId).getDocument { snapshot, _ in
                    guard let data = snapshot?.data() else { return }
                    let user = User(dictionary: data)
                    self.messages.append(Message(user: user, dictionary: messageData))
                    self.messages.sort(by: { $0.timestamp.dateValue() < $1.timestamp.dateValue() })

                }
            }
        }
    }
    
    func sendMessage(_ messageText: String) {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        
        let currentUserRef = COLLECTION_MESSAGES.document(currentUid).collection(user.id).document()
        let receivingUserRef = COLLECTION_MESSAGES.document(user.id).collection(currentUid)
        let receivingRecentRef = COLLECTION_MESSAGES.document(user.id).collection("recent-messages")
        let currentRecentRef = COLLECTION_MESSAGES.document(currentUid).collection("recent-messages")
        let messageID = currentUserRef.documentID
        
        let data : [String : Any] = [
            "isRead": 0,
            "text": messageText,
            "id": messageID,
            "fromId": currentUid,
            "toId": user.id,
            "timestamp": Timestamp(date: Date())
        ]

        currentUserRef.setData(data)
        receivingUserRef.document(messageID).setData(data)
        currentRecentRef.document(self.user.id).setData(data)
        
        let userNotifRef = receivingRecentRef.document(currentUid)
        
        userNotifRef.getDocument { snapshot, _ in
            if let currentUser = AuthViewModel.shared.user {
                guard let userGotThisNotif = snapshot?.exists else { return }
                if userGotThisNotif {
                    guard let data = snapshot?.data() else { return }
                    guard let isRead = data["isRead"] as? Int else { return }
                    if isRead == 1 {
                        OneSignal.postNotification(["contents": ["en": "New message from \(currentUser.fullname)"], "include_player_ids": [self.user.playerId]])
                    }
                } else {
                    OneSignal.postNotification(["contents": ["en": "New message from \(currentUser.fullname)"], "include_player_ids": [self.user.playerId]])
                }
                receivingRecentRef.document(currentUid).setData(data)
            }
        }
        
        COLLECTION_MESSAGES.document(currentUid).getDocument { snapshot, _ in
            guard let exist = snapshot?.exists else { return }
            if exist {
                guard let data = snapshot?.data() else { return }
                guard let messageCount = data["messageCount"] as? Int else { return }
                let messageData : [String : Any] = [
                    "messageCount" : messageCount + 1
                ]
                
                COLLECTION_MESSAGES.document(currentUid).setData(messageData) { _ in
                    if messageCount + 1 >= 20 {
                        let data : [String : Any] = [
                            "messageCount" : 1
                        ]
                        
                        COLLECTION_MESSAGES.document(currentUid).setData(data) { _ in
                            self.showChatAd = true
                        }
                    }
                }
            } else {
                let data : [String : Any] = [
                    "messageCount" : 1
                ]
                
                COLLECTION_MESSAGES.document(currentUid).setData(data) { _ in
                }
            }
        }
        
        
        
    }
}
