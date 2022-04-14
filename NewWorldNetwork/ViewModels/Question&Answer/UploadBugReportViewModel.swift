//
//  UploadBugReportViewModel.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 29.09.2021.
//


import SwiftUI
import Firebase

class UploadBugReportViewModel: ObservableObject {
    @Binding var bugReportSent: Bool
    
    init(bugReportSent: Binding<Bool>) {
        self._bugReportSent = bugReportSent
    }
    
    func sendBugReport(title: String, caption: String) {
        guard let user = AuthViewModel.shared.user else { return }
        let docRef = Firestore.firestore().collection("bug-reports").document()
        
        
        let data: [String: Any] = [
            "1 - User UID": user.id,
            "2 - Full Name": user.fullname,
            "3 - Username": user.username,
            "4---------------": "-----------------------",
            "5 - Report ID": docRef.documentID,
            "6 - Report Tıtle": title,
            "7 - Report Content": caption,
            "8 - Report Time": Timestamp(date: Date())
        ]
        
        docRef.setData(data) { _ in
            self.bugReportSent = true
        }
    }
    
    
    func sendBugReportWithImage(title: String, caption: String, selectedImage: UIImage) {
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
                    let docRef = Firestore.firestore().collection("bug-reports").document()
                    
                    
                    let data: [String: Any] = [
                        "1 - User UID": user.id,
                        "2 - Full Name": user.fullname,
                        "3 - Username": user.username,
                        "4---------------": "-----------------------",
                        "5 - Report ID": docRef.documentID,
                        "6 - Report Tıtle": title,
                        "7 - Report Content": caption,
                        "8 - Report Image": imageUrl,
                        "9 - Report Time": Timestamp(date: Date())
                    ]
                    
                    docRef.setData(data) { _ in
                        self.bugReportSent = true
                    }
                }
            }
        }
    }
}
