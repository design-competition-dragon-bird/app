//
//  User.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import Foundation
import FirebaseFirestore

class User{
    
    static let instance = User()
    
    var userId: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var password: String!
    var userType: String!
    var phone: String!
    var selectedButton: String!
    
    private var db: Firestore!
    
    init() {
        // do nothing
        self.userId = nil
        self.firstName = nil
        self.lastName = nil
        self.email = nil
        self.password = nil
        self.userType = nil
        self.phone = nil
        self.selectedButton = "default button"

        self.db = Firestore.firestore()
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
    
    func storePressureData(intArray: [Int], success: @escaping () -> (), failure: @escaping () -> ()){
        self.db.collection("User").document(self.userId).collection("Pressure Data").document(self.get_current_time()).setData([
            "Data": intArray
        ], merge: true) { (err) in
            // check for error
            if err != nil{
                failure()
            }
            success()
        }
    }
    
    func getPressureData(success: @escaping () -> (), failure: @escaping () -> ()){
        self.db.collection("User").document(self.userId).collection("Pressure Data").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //get that day's data
                    document.documentID
                    let today_Data = self.get_current_time()
                    var found = false
                    for i in 0...9 {
                        if today_Data.index(today_Data.startIndex, offsetBy: i) != document.documentID.index(document.documentID.startIndex, offsetBy: i) {
                            break
                        }
                        else if i == 9 {
                            found = true
                        }
                    }
                    if found {
                        
                    }
                    
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }

    func storeGyroData(pitch: Float, roll: Float, yaw: Float, success: @escaping () -> (), failure: @escaping () -> ()){
        self.db.collection("User").document(self.userId).collection("Gyro Data").document(self.get_current_time()).setData([
            "Pitch": pitch,
            "Roll": roll,
            "yaw": yaw
        ], merge: true) { (err) in
            // check for error
            if err != nil{
                failure()
            }
            success()
        }
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
        
        return current_time
    }
}
