//
//  FollowStatsViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 27.09.2021.
//

import SwiftUI
import Firebase

class FollowStatsViewModel: ObservableObject {
    let user: User
    @Published var followerUser = [User]()
    @Published var followingUser = [User]()
    
    init(user: User) {
        self.user = user
        getFollowingUsers()
        getFollowerUsers()
    }
    
    func stats(forFilter filter: FollowStatsFilterOption) -> [User] {
        switch filter {
        case .following: return followingUser
        case .followers: return followerUser
        }
    }
}

/// MARK: - API

extension FollowStatsViewModel {
    func getFollowingUsers() {
        COLLECTION_FOLLOWING.document(user.id).collection("user-following").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            documents.forEach { document in
                COLLECTION_USERS.document(document.documentID).getDocument { document, _ in
                    guard let data = document?.data() else { return }
                    self.followingUser.append(User(dictionary: data))
                }
                
            }
        }
    }
    
    func getFollowerUsers() {
        COLLECTION_FOLLOWERS.document(user.id).collection("user-followers").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            documents.forEach { document in
                COLLECTION_USERS.document(document.documentID).getDocument { document, _ in
                    guard let data = document?.data() else { return }
                    self.followerUser.append(User(dictionary: data))
                }
                
            }
        }
    }
}

