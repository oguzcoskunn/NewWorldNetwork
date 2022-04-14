//
//  Message.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 15.08.2021.
//

import Firebase

struct Message: Identifiable {
    let text: String
    let user: User
    let toId: String
    let fromId: String
    let isFromCurrentUser: Bool
    let timestamp: Timestamp
    let id: String
    
    var chatPartnerId: String { return isFromCurrentUser ? toId : fromId }
    
    init(user: User, dictionary: [String : Any]) {
        self.user = user
        
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id = dictionary["id"] as? String ?? ""
    }
    
    var timestampString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        let diffComponents = Calendar.current.dateComponents([.day], from: timestamp.dateValue(), to: Date())
        let day = diffComponents.day
        if let day = day {
            if day > 0 {
                formatter.dateFormat = "MM/dd/yy, h:mm a"
                return formatter.string(from: timestamp.dateValue())
            } else {
                return formatter.string(from: timestamp.dateValue())
            }
        } else {
            return formatter.string(from: timestamp.dateValue())
        }
    }
}

