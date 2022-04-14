//
//  AuthViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 24.08.2021.
//

import SwiftUI
import Firebase
import OneSignal

class AuthViewModel: ObservableObject {
    @Published var loadingNow: Bool = false
    @Published var userSession: Firebase.User?
    @Published var isAuthenticating = false
    @Published var error: Error?
    @Published var customError: String = ""
    @Published var user: User?
    @Published var supportUser: User?
    @Published var blockedUsers = [User]()
    
    static let shared = AuthViewModel()
    
    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
        getBlockedUsers()
        getUserBanStatus()
        fetchSupportUser()
    }
    
    func getUserBanStatus() {
        Firestore.firestore().collection("banned-users").addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            guard let currentUid = self.userSession?.uid else { return }
            
            changes.forEach { change in
                let uid = change.document.documentID
                
                if uid == currentUid {
                    if self.userSession != nil {
                        self.signOut()
                    }
                }
            }
        }
    }
    
    func getBlockedUsers() {
        guard let currentUid = self.userSession?.uid else { return }
        COLLECTION_USERS.document(currentUid).collection("blocked-users").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            if !self.blockedUsers.isEmpty {
                self.blockedUsers.removeAll()
            }
            documents.forEach { document in
                COLLECTION_USERS.document(document.documentID).getDocument { snapshot, _ in
                    guard let data = snapshot?.data() else { return }
                    self.blockedUsers.append(User(dictionary: data))
                    self.blockedUsers = self.blockedUsers.sorted { $0.fullname < $1.fullname }
                }
            }
            
//            Firestore.firestore().collection("banned-users").getDocuments { snapshot, _ in
//                guard let documents = snapshot?.documents else { return }
//                documents.forEach { document in
//                    COLLECTION_USERS.document(document.documentID).getDocument { snapshot, _ in
//                        guard let data = snapshot?.data() else { return }
//                        self.blockedUsers.append(User(dictionary: data))
//                    }
//                }
//            }
        }
    }
    
    func unblockUser(userUid: String) {
        guard let currentUid = self.userSession?.uid else { return }
        COLLECTION_USERS.document(currentUid).collection("blocked-users").document(userUid).delete() { _ in
            self.getBlockedUsers()
        }
    }
    
    func checkUidForBlock(userUid: String) -> Bool {
        var result = false
        self.blockedUsers.forEach { blockedUser in
            if blockedUser.id == userUid {
                result = true
            }
        }
        return result
    }
    
    func login(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.loadingNow = false
                self.error = error
                return
            }
            
            Firestore.firestore().collection("banned-users").getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                guard let currentUid = result?.user.uid else { return }
                
                var userBanStatus = false
                
                documents.forEach { document in
                    let uid = document.documentID
                    
                    if uid == currentUid {
                        userBanStatus = true
                    }

                }
                
                if !userBanStatus {
                    self.userSession = result?.user
                    self.fetchUser()
                    self.loadingNow = false
                    self.deletePlayerIdIfAlreadyExist()
                } else {
                    self.loadingNow = false
                    self.customError = "Your account has been suspended!"
                }
                
            }
        }
    }
    
    
    func registerUser(email: String, password: String, username: String, fullname: String, profileImage: UIImage) {
        let username = username.lowercased()
        COLLECTION_USERS.getDocuments { snapshot, _ in
            var usernameAvailable = true
            guard let documents = snapshot?.documents else { return }
            documents.forEach { document in
                let data = document.data()
                guard let otherUsername = data["username"] as? String else { return }
                if username == otherUsername {
                    self.loadingNow = false
                    usernameAvailable = false
                    self.customError = "This username already using!"
                }
            }
            if !usernameAvailable { return } else {
                guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
                let filename = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child(filename)
                
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        self.loadingNow = false
                        self.error = error
                        return
                    }
                    
                    storageRef.putData(imageData, metadata: nil) { _, _ in
                        
                        storageRef.downloadURL { url, _ in
                            guard let profileImageUrl = url?.absoluteString else { return }
                        
                            guard let user = result?.user else { return }
                                
                            let status = OneSignal.getDeviceState()
                            let playerId = status?.userId
                            if let playerId = playerId {
                                let data = [
                                    "email": email,
                                    "username": username,
                                    "fullname": fullname,
                                    "profileImageUrl": profileImageUrl,
                                    "aboutMe": "About Me",
                                    "playerId": playerId,
                                    "uid": user.uid
                                ]
                                
                                COLLECTION_USERS.document(user.uid).setData(data) { _ in
                                    self.userSession = user
                                    self.fetchUser()
                                    self.loadingNow = false
                                    self.deletePlayerIdIfAlreadyExist()
                                }
                            } else {
                                let data = [
                                    "email": email,
                                    "username": username,
                                    "fullname": fullname,
                                    "profileImageUrl": profileImageUrl,
                                    "aboutMe": "About Me",
                                    "uid": user.uid
                                ]
                                
                                COLLECTION_USERS.document(user.uid).setData(data) { _ in
                                    self.userSession = user
                                    self.fetchUser()
                                    self.loadingNow = false
                                    self.deletePlayerIdIfAlreadyExist()
                                }
                            }
                                
                        }
                    }
                }
            }
        }
    }
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.loadingNow = false
                self.error = error
                return
            }
            self.loadingNow = false
            self.customError = "Password reset link has been sent to the mail."
            
        }
    }
    
    func updateUser(fullname: String, aboutMe: String, newProfileImage: UIImage?) {
        if let profileImage = newProfileImage {
            guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
            let filename = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child(filename)
            
            storageRef.putData(imageData, metadata: nil) { _, _ in
                
                storageRef.downloadURL { url, _ in
                    guard let profileImageUrl = url?.absoluteString else { return }
                        
                    if let user = self.user {
                        let status = OneSignal.getDeviceState()
                        let playerId = status?.userId
                        if let playerId = playerId {
                            let data = [
                                "email": user.email,
                                "username": user.username.lowercased(),
                                "fullname": fullname.isEmpty ? user.fullname : fullname,
                                "profileImageUrl": profileImageUrl,
                                "aboutMe": aboutMe.isEmpty ? user.aboutme : aboutMe,
                                "playerId": playerId,
                                "uid": user.id
                            ]
                                
                            COLLECTION_USERS.document(user.id).setData(data) { _ in
                                self.fetchUser()
                            }
                        } else {
                            let data = [
                                "email": user.email,
                                "username": user.username.lowercased(),
                                "fullname": fullname.isEmpty ? user.fullname : fullname,
                                "profileImageUrl": profileImageUrl,
                                "aboutMe": aboutMe.isEmpty ? user.aboutme : aboutMe,
                                "uid": user.id
                            ]
                                
                            COLLECTION_USERS.document(user.id).setData(data) { _ in
                                self.fetchUser()
                            }
                        }
                    }
                    
                        
                }
            }
        } else {
            if let user = self.user {
                let status = OneSignal.getDeviceState()
                let playerId = status?.userId
                if let playerId = playerId {
                    let data = [
                        "email": user.email,
                        "username": user.username.lowercased(),
                        "fullname": fullname.isEmpty ? user.fullname : fullname,
                        "profileImageUrl": user.profileImageUrl,
                        "aboutMe": aboutMe.isEmpty ? user.aboutme : aboutMe,
                        "playerId": playerId,
                        "uid": user.id
                    ]
                    
                    COLLECTION_USERS.document(user.id).setData(data) { _ in
                        self.fetchUser()
                    }
                } else {
                    let data = [
                        "email": user.email,
                        "username": user.username.lowercased(),
                        "fullname": fullname.isEmpty ? user.fullname : fullname,
                        "profileImageUrl": user.profileImageUrl,
                        "aboutMe": aboutMe.isEmpty ? user.aboutme : aboutMe,
                        "uid": user.id
                    ]
                    
                    COLLECTION_USERS.document(user.id).setData(data) { _ in
                        self.fetchUser()
                    }
                }
            }
        }
    }
    
    func signOut() {
        if let user = user {
            let newData = [
                "email": user.email,
                "username": user.username,
                "fullname": user.fullname,
                "profileImageUrl": user.profileImageUrl,
                "aboutMe": user.aboutme,
                "uid": user.id
            ]
            
            COLLECTION_USERS.document(user.id).setData(newData) { _ in
            }
        }
  
        userSession = nil
        user = nil
        try? Auth.auth().signOut()
    }
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            self.user = User(dictionary: data)
            if let user = self.user {
                let status = OneSignal.getDeviceState()
                let playerId = status?.userId
                if let playerId = playerId {
                    let data = [
                        "email": user.email,
                        "username": user.username.lowercased(),
                        "fullname": user.fullname,
                        "profileImageUrl": user.profileImageUrl,
                        "aboutMe": user.aboutme,
                        "playerId": playerId,
                        "uid": user.id
                    ]
                    
                    COLLECTION_USERS.document(user.id).setData(data) { _ in
                        self.user = User(dictionary: data)
                    }
                }
            }
        }
    }
    
    func fetchSupportUser() {
        COLLECTION_USERS.document("mCJlIwtHQHRb6zPIBcfLTWX9vdY2").getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }
            self.supportUser = User(dictionary: data)
        }
    }
    
    
    func tabTitle(forIndex index: Int) -> String {
        switch index {
        case 0: return "Home"
        case 1: return "Search"
        case 2: return "Messages"
        default: return ""
        }
    }
    
    func deletePlayerIdIfAlreadyExist() {
        COLLECTION_USERS.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            documents.forEach { document in
                let data = document.data()
                guard let otherPlayerId = data["playerId"] as? String else { return }
                let status = OneSignal.getDeviceState()
                let playerId = status?.userId
                if playerId == otherPlayerId {
                    guard let email = data["email"] as? String else { return }
                    guard let username = data["username"] as? String else { return }
                    guard let fullname = data["fullname"] as? String else { return }
                    guard let profileImageUrl = data["profileImageUrl"] as? String else { return }
                    guard let aboutMe = data["aboutMe"] as? String else { return }
                    guard let targetUid = data["uid"] as? String else { return }
                    let newData = [
                        "email": email,
                        "username": username,
                        "fullname": fullname,
                        "profileImageUrl": profileImageUrl,
                        "aboutMe": aboutMe,
                        "uid": targetUid
                    ]
                    
                    COLLECTION_USERS.document(targetUid).setData(newData) { _ in
                    }
                }
            }
        }
    }
}

