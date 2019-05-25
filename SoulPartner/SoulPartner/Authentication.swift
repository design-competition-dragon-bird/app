//
//  Authentication.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// global DispatchGroup for thread control
let global_dispatchGroup = DispatchGroup()
func run(completion: @escaping() -> Void)
{
    DispatchQueue.main.async{
        completion()
    }
}


class Authenticate{
    static let instance = Authenticate()
    
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // For user registration
    var registration_isValid:Bool = false
    func register_user(email: String, passWord: String, success: @escaping () -> (), failure: @escaping () -> ())
    {
        Auth.auth().createUser(withEmail: email, password: passWord) { (user, error) in
            // error creating new user
            if let _ = error{
                failure()
            }
            else{
                if let _ = Auth.auth().currentUser{
                    Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                        // cound not send email verification
                        if let _ = error{
                            failure()
                        }
                        else{
                            success()
                        }
                    })
                }
                else{
                    // user alread in the database, cannot recreate user
                    failure()
                }
            }
        }
    }
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // For user authentication
    func authenticate_user_login(email: String, passWord: String, success: @escaping () -> (), failure: @escaping () -> ())
    {
        Auth.auth().signIn(withEmail: email, password: passWord) { (user, error) in
            if let _ = error{
                failure()
            }
            else{
                print("auth success")
                // check if user has verified their email
                if let user = Auth.auth().currentUser{
                    if !user.isEmailVerified{
                        failure()
                    }
                    else {
                        success()
                    }
                }
                
            }
        }
    }
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // For sending password reset link
    func send_password_reset_link(email: String, success: @escaping () -> (), failure: @escaping () -> ()){
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            // error sending password reset link
            if error != nil{
                failure()
            }
            else{
                // password reset link send
                success()
            }
        }
    }
}
