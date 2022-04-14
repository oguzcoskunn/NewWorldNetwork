//
//  NotificationCountViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 14.09.2021.
//

import SwiftUI

class NotificationCountViewModel: ObservableObject {
    @Published var notificationCount = 0
    @Published var messageNotificationCount = 0
    
    init() {
        getNotificationCount()
        getMessageNotificationCount()
    }
    
    func getNotificationCount() {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        let notificationRef = COLLECTION_USERS.document(currentUid).collection("user-notifications")
        notificationRef.addSnapshotListener { snapshot, _ in
            self.notificationCount = 0
            notificationRef.getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                documents.forEach { document in
                    guard let isRead = document["isRead"] as? Int else { return }
                    if isRead == 0 {
                        self.notificationCount = self.notificationCount + 1
                    }
                }
            }
        }
    }
    
    func getMessageNotificationCount() {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        let notificationRef = COLLECTION_MESSAGES.document(currentUid).collection("recent-messages")
        notificationRef.addSnapshotListener { snapshot, _ in
            self.messageNotificationCount = 0
            notificationRef.getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                documents.forEach { document in
                    guard let isRead = document["isRead"] as? Int else { return }
                    if isRead == 0 {
                        self.messageNotificationCount = self.messageNotificationCount + 1
                    }
                }
            }
        }
    }
}
