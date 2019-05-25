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
            else{
                success()
            }
        }
    }
    
    func registerUser(success: @escaping () -> (), failure: @escaping () -> ()){
        Authenticate.instance.register_user(email: self.email, passWord: self.password, success: {
            // user registration success
            success()
        }) {
            // user registration failure
            failure()
        }
    }
}
