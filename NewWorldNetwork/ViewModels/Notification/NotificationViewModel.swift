//
//  NotificationViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 12.09.2021.
//

import SwiftUI
import Firebase

class NotificationViewModel: ObservableObject {
    @Published var notifications = [Notification]()
    
    init() {
        getNotifications()
    }
    
    func getNotifications() {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        COLLECTION_USERS.document(currentUid).collection("user-notifications").addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges else { return }
            changes.forEach { change in
                guard let documents = snapshot?.documents else { return }
                self.notifications = documents.map({ Notification(dictionary: $0.data()) })
                self.notifications.sort(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
            }
        }
    }
    
    func setNotificationsReaded() {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        let notificationRef = COLLECTION_USERS.document(currentUid).collection("user-notifications")
        notificationRef.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            documents.forEach { document in
                notificationRef.document(document.documentID).updateData(["isRead": 1]) { _ in
                    
                }
            }
        }
    }
    
    func setMessagesReaded() {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        let notificationRef = COLLECTION_MESSAGES.document(currentUid).collection("recent-messages")
        notificationRef.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            documents.forEach { document in
                notificationRef.document(document.documentID).updateData(["isRead": 1]) { _ in
                    
                }
            }
        }
    }
    
//    func fetchNotifications() {
//        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
//        let notificationRef = COLLECTION_USERS.document(currentUid).collection("user-notifications")
//        notificationRef.getDocuments { snapshot, _ in
//            guard let documents = snapshot?.documents else { return }
//            documents.forEach { document in
//                guard let isRead = document["isRead"] as? Int else { return }
//                if isRead == 0 {
//                    self.notificationCount = self.notificationCount + 1
//                }
//            }
//        }
//    }
}
