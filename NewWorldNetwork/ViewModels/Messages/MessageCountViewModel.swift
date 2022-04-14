//
//  MessageCountViewModel.swift
//  NewWorldSocial
//
//  Created by Oğuz Coşkun on 14.09.2021.
//

import SwiftUI

class MessageCountViewModel: ObservableObject {
    @Published var notificationCount = 0
    
    init() {
        getNotificationCount()
    }
    
    func getNotificationCount() {
        self.notificationCount = 0
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        COLLECTION_USERS.document(currentUid).collection("user-notifications").addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges else { return }
            changes.forEach { change in
                guard let isRead = change.document["isRead"] as? Int else { return }
                if isRead == 0 {
                    self.notificationCount = self.notificationCount + 1
                }
                
            }
        }
    }
}
