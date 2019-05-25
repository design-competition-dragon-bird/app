//
//  MessagesViewController.swift
//  HeatMap
//
//  Created by Ravi Patel on 5/17/19.
//  Copyright © 2019 Design Comeptition. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import MessageInputBar
import Firebase
import FirebaseFirestore
import FirebaseDatabase

class MessageViewController: MessagesViewController{
    
    var messages: [Message] = []
    var member: Member!
    var dbFirestore: Firestore!
    var dbRealTime: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbFirestore = Firestore.firestore()
        dbRealTime = Database.database().reference()
        
        member = Member(name: "Dragon Bird", color: .blue)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        // Read from database in realtime
        dbRealTime.child("Chat1").child("messages").observe(.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let sorted_value = value?.sorted(by: { (arg0, arg1) -> Bool in
                
                
                let (_, value1) = arg0
                let (_, value2) = arg1
                
                let left = value1 as! NSDictionary
                let right = value2 as! NSDictionary
                
                let left_time = left["timestamp"] as! String
                let right_time = right["timestamp"] as! String
                
                
                return left_time < right_time ? true : false
            })
            
            self.messages.removeAll()
            if let val = sorted_value {
                for i in val{
                    let message = i.value as! NSDictionary
                    self.messages.append(Message(name: message.value(forKey: "member") as! String, text: message.value(forKey: "text") as! String, messageId: message.value(forKey: "messageId") as! String, timestame: message.value(forKey: "timestamp") as! String))
                    print(i.value)
                }
            }

//            let newMessage = Message(
//                name: "Dragon Bird",
//                text: "this is text",
//                messageId: UUID().uuidString,
//                timestame: self.get_current_time())
//
//            self.messages.append(newMessage)
            self.messagesCollectionView.reloadData()
        }) { (err) in
            print("error reading from database.......error = ", err)
        }
        
        print(get_current_time())
    }
    
    @objc func compareValue(one: Any, two: Any){
        print(one)
    }
    
    func get_current_time() -> String {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        var current_hour = ""
        
        if hour < 10 {
            current_hour = String("0") + String(hour)
        }
        else if hour > 12 {
            current_hour = String(hour - 12)
        }
        else{
            current_hour = String(hour)
        }
        
        let current_month = month < 10 ? String("0") + String(month) : String(month)
        let current_day = day < 10 ? String("0") + String(day) : String(day)
        let current_minute = minutes < 10 ? String("0") + String(minutes) : String(minutes)
        let current_seconds = seconds < 10 ? String("0") + String(seconds) : String(seconds)
        
        var current_time = String(year) + ":" + String(current_month) + ":" + String(current_day) + ":" + String(current_hour) + ":" + String(current_minute) + ":" + String(current_seconds)
    
        if hour >= 12 {
            current_time = current_time + " PM"
        }
        else{
            current_time = current_time + " AM"
        }
        
        return current_time
    }
    
}

extension MessageViewController: MessagesDataSource {
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 12
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: message.sender.displayName, attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}


extension MessageViewController: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
}

extension MessageViewController: MessagesDisplayDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
//        let message = messages[indexPath.section]
        let color = UIColor.blue
        avatarView.backgroundColor = color
        
    }
}


extension MessageViewController: MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        let newMessage = Message(
            name: self.member.name,
            text: text,
            messageId: UUID().uuidString,
            timestame: self.get_current_time())
        
        self.dbRealTime.child("Chat1").child("messages").child(newMessage.messageId).setValue(["member": newMessage.name, "messageId": newMessage.messageId, "text": newMessage.text, "timestamp": newMessage.timestame])
        
        messages.append(newMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
        
        
    }
}
