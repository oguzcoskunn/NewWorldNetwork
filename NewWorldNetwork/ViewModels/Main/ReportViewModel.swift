//
//  ReportViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 2.10.2021.
//

import Foundation
import Firebase

class ReportViewModel:ObservableObject {
    func reportTheContent(contentID: String, contentOwner: String, type: String) {
        let data = [
            "reportType": type,
            "reportedContentId": contentID,
            "reportedUser": contentOwner
        ]
        
        Firestore.firestore().collection("reports").document(contentID).setData(data) { _ in
        }
    }
    
    func reportTheContentandBlockUser(contentID: String, contentOwner: String, type: String) {
        let data = [
            "reportType": type,
            "reportedContentId": contentID,
            "reportedUser": contentOwner
        ]
        
        Firestore.firestore().collection("reports").document(contentID).setData(data) { _ in
        }
        
        blockUser(blockedUserUid: contentOwner)
    }
    
    func blockUser(blockedUserUid: String) {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        COLLECTION_USERS.document(uid).collection("blocked-users").document(blockedUserUid).setData([:]) { _ in
            COLLECTION_FOLLOWING.document(uid).collection("user-following").document(blockedUserUid).delete() { _ in
                COLLECTION_FOLLOWERS.document(blockedUserUid).collection("user-followers").document(uid).delete() { _ in
                }
            }
        }
    }
}
