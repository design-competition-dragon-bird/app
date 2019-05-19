//
//  Message.swift
//  HeatMap
//
//  Created by Ravi Patel on 5/17/19.
//  Copyright © 2019 Design Comeptition. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import Firebase
import FirebaseFirestore
import FirebaseDatabase

struct Member {
    let name: String
    let color: UIColor
}

struct Message {
    let name: String
    let text: String
    let messageId: String
    let timestame: String
}

struct Chart{
    var chatId: String
    var member1: Member
    var member2: Member
    var messages: [Message] = []
}

extension Message: MessageType{
    var sender: Sender {
        return Sender(id: name, displayName: name)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}

class ReadFromDatabase {
    static let instance = ReadFromDatabase()
    
    private var dbFirestore: Firestore
    private var dbRealTime: DatabaseReference
    
    init() {
        dbFirestore = Firestore.firestore()
        dbRealTime = Database.database().reference()
    }
}
