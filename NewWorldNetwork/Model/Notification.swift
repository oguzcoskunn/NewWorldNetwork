//
//  Notification.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 12.09.2021.
//

import Firebase

struct Notification: Identifiable {
    let id: String
    let isRead: Bool
    let notifyType: String
    let tweetID: String
    let senderUsername: String
    let senderProfileImageUrl: String
    let senderImageUrl: String
    let senderFullname: String
    let senderCaption: String
    let senderUid: String
    let timestamp: Timestamp
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.isRead = dictionary["isRead"] as? Bool ?? false
        self.notifyType = dictionary["notifyType"] as? String ?? ""
        self.tweetID = dictionary["tweetID"] as? String ?? ""
        self.senderUsername = dictionary["senderUsername"] as? String ?? ""
        self.senderProfileImageUrl = dictionary["senderProfileImageUrl"] as? String ?? ""
        self.senderImageUrl = dictionary["senderImageUrl"] as? String ?? ""
        self.senderCaption = dictionary["senderCaption"] as? String ?? ""
        self.senderFullname = dictionary["senderFullname"] as? String ?? ""
        self.senderUid = dictionary["senderUid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
    
    
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        let diffComponents = Calendar.current.dateComponents([.day], from: timestamp.dateValue(), to: Date())
        let day = diffComponents.day
        if let day = day {
            if day > 0 {
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yy, h:mm a"
                return formatter.string(from: timestamp.dateValue())
            } else {
                return formatter.string(from: timestamp.dateValue(), to: Date()) ?? ""
            }
        } else {
            return formatter.string(from: timestamp.dateValue(), to: Date()) ?? ""
        }
    }
}

