//
//  User.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseDatabase

class User{
    
    static let instance = User()
    
    var userId: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var password: String!
    var userType: String!
    var phone: String!
    var chat_ids: [String]!
    var selectedButton: String!
    
    private var db: Firestore!
    private var ref: DatabaseReference!
    
    init() {
        // do nothing
        self.userId = nil
        self.firstName = nil
        self.lastName = nil
        self.email = nil
        self.password = nil
        self.userType = nil
        self.phone = nil
        self.chat_ids = nil
        self.selectedButton = "default button"

        self.db = Firestore.firestore()
        self.ref = Database.database().reference()
    }
    
    func getUserInfo(UID uid: String, success: @escaping () -> (), failure: @escaping () -> ()){
        self.db.collection("User").document(uid).getDocument { (snapshot, err) in
            if err != nil {
                failure()
            }
            else{
                let data = snapshot?.data()
                self.firstName = (data!["First Name"] as! String)
                self.lastName = (data!["Last Name"] as! String)
                self.email = (data!["Email"] as! String)
                self.phone = (data!["Phone"] as! String)
                self.userType = (data!["User Type"] as! String)
//                print("data = ", data)
                success()
            }
        }
    }
    
    
    func getMembersFromChat(chat_id: String, success: @escaping (_ member1: String, _ member2: String) -> (), failure: @escaping () -> ()) {
        self.ref.child(chat_id).observeSingleEvent(of: .value, with: { (snapshot) in
            // code
            let value = snapshot.value as? NSDictionary
            let mem1 = value?["member1"] as? String ?? ""
            let mem2 = value?["member2"] as? String ?? ""
//            print("mem1 = ", mem1)
//            print("mem2 = ", mem2)
            success(mem1, mem2)
        }) { (err) in
            // error
            failure()
        }
    }
    
    func storeUserInfo(success: @escaping () -> (), failure: @escaping () -> ()){
        self.db.collection("User").document(self.userId).setData([
            "First Name": self.firstName!,
            "Last Name": self.lastName!,
            "Email": self.email!,
            "Phone": self.phone!,
            "User Type": self.userType!
        ], merge: true) { (err) in
            // do nothing
            if err != nil{
                failure()
            }
            success()
        }
    }
    
    func registerUser(success: @escaping () -> (), failure: @escaping () -> ()){
        Authenticate.instance.register_user(email: self.email, passWord: self.password, success: {
            // user registration success
            print("success user registration...")
            success()
        }) {
            // user registration failure
            print("failure during user registration...")
            failure()
        }
    }
    
    func getChats(success: @escaping () -> (), failure: @escaping () -> ()) {
        self.db.collection("User").document(self.userId).getDocument { (snapshot, err) in
            if let document = snapshot, snapshot!.exists {
                let data = document.data()!
                let chats = data["Chat IDs"] as? [String]
                
                if chats != nil {
                    self.chat_ids = chats
                    success()
                }
                else{
                    failure()
                }
            }
            else {
                print("Document does not exist")
                failure()
            }
        }
    }
    
    func storePressureData(intArray: [Int], success: @escaping () -> (), failure: @escaping () -> ()){
        let current = self.get_current_time()
        self.db.collection("User").document(self.userId).collection("Pressure Data").document(current[0]).collection(current[1]).document(current[2]).setData([
            current[3] : intArray
        ], merge: true) { (error) in
            if error != nil{
                failure()
            }
            else{
                success()
            }
        }
    }
    
    func getPressureData(success: @escaping (_ PressureData: [[Int]]) -> (), failure: @escaping () -> ()){
        let current = self.get_current_time()

        self.db.collection("User").document(self.userId).collection("Pressure Data").document(current[0]).collection(current[1]).document(current[2]).getDocument { (snap, err) in
            if let error = err {
                print("Error getting documents: \(error)")
                failure()
            }
            else{
                if let data = snap?.data(){
                    let keys = data.keys.sorted()
                    var pressureData = [[Int]]()
                    for i in keys{
                        pressureData.append(data[i] as! [Int])
                    }
                    success(pressureData)
                }
                else{
                    failure()
                }
               
            }
        }
    }

    func storeGyroData(pitch: Float, roll: Float, yaw: Float, success: @escaping () -> (), failure: @escaping () -> ()){
        
        let current = self.get_current_time()
        self.db.collection("User").document(self.userId).collection("Gyro Data").document(current[0]).collection(current[1]).document(current[2]).collection(current[3]).addDocument(data: [
            "Pitch": pitch,
            "Roll": roll,
            "yaw": yaw
        ]) { (err) in
            //check for error
            if err != nil{
                failure()
            }
            success()
        }
    }
    
    func get_current_time() -> [String] {
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
        else if hour > 12 {//Converts to 12 hour format
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
        
        return [String(year), String(current_month), current_day, current_time]
    }
}
