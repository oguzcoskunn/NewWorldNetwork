//
//  UploadTweetViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 25.08.2021.
//

import SwiftUI
import Firebase

class UploadTweetViewModel: ObservableObject {
    @Binding var isPresented: Bool
    @Binding var tweetUploaded: Bool
    @Published var loadingNow: Bool = false
    
    init(isPresented: Binding<Bool>, tweetUploaded: Binding<Bool>) {
        self._isPresented = isPresented
        self._tweetUploaded = tweetUploaded
    }
    
    func uploadTweet(caption: String) {
        guard let user = AuthViewModel.shared.user else { return }
        let docRef = COLLECTION_TWEETS.document()
        
        let data: [String: Any] = [
            "uid": user.id,
            "caption": caption,
            "fullname": user.fullname,
            "timestamp": Timestamp(date: Date()),
            "username": user.username,
            "profileImageUrl": user.profileImageUrl,
            "likes": 0,
            "replies": 0,
            "id": docRef.documentID
        ]
        

        docRef.setData(data) { _ in
            
            guard let uid = AuthViewModel.shared.userSession?.uid else { return }
            let userTweetsRef = COLLECTION_USERS.document(uid).collection("user-tweets")
            userTweetsRef.document(docRef.documentID).setData([:]) { _ in
                self.isPresented = false
                self.loadingNow = false
                self.tweetUploaded = true
            }
                
        }
    }
    
    func uploadTweetwithImage(caption: String, selectedImage: UIImage) {
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(filename)
        
        DispatchQueue.main.async {
            storageRef.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    print("DEBUG: Failed to upload image for tweet \(error.localizedDescription)")
                    return
                }

                storageRef.downloadURL { url, _ in
                    guard let imageUrl = url?.absoluteString else { return }
                
                    guard let user = AuthViewModel.shared.user else { return }
                    let docRef = COLLECTION_TWEETS.document()
                    
                    let data: [String: Any] = [
                        "uid": user.id,
                        "caption": caption,
                        "imageUrl": imageUrl,
                        "fullname": user.fullname,
                        "timestamp": Timestamp(date: Date()),
                        "username": user.username,
                        "profileImageUrl": user.profileImageUrl,
                        "likes": 0,
                        "replies": 0,
                        "id": docRef.documentID
                    ]
                    

                    docRef.setData(data) { _ in
                        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
                        let userTweetsRef = COLLECTION_USERS.document(uid).collection("user-tweets")
                        userTweetsRef.document(docRef.documentID).setData([:]) { _ in
                            self.isPresented = false
                            self.loadingNow = false
                            self.tweetUploaded = true
                        }
                            
                    }
                        
                }
            }
        }
        

    }
    
///    Uses completion handler to dismiss view
    
//    func uploadTweet(caption: String, completion: @escaping((Error?) -> Void)) {
//        guard let user = AuthViewModel.shared.user else { return }
//        let docRef = COLLECTION_TWEETS.document()
//
//        let data: [String: Any] = [
//            "uid": user.id,
//            "caption": caption,
//            "fullname": user.fullname,
//            "timestamp": Timestamp(date: Date()),
//            "username": user.username,
//            "profileImageUrl": user.profileImageUrl,
//            "likes": 0,
//            "id": docRef.documentID
//        ]
//
//        docRef.setData(data, completion: completion)
//    }
}
