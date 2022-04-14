//
//  Constants.swift
//  NewWorldNetwork
//
//  Created by Oğuz Coşkun on 24.08.2021.
//

import Firebase

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_TWEETS = Firestore.firestore().collection("tweets")
let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")
let COLLECTION_QUESTIONS = Firestore.firestore().collection("questions")
    
