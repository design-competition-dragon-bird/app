//
//  ForgotPasswordViewController.swift
//  SoulPartner
//
//  Created by Saikiran Komatineni on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var signUpButton: UIButton!
    let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 18),
        .foregroundColor: UIColor.white,
        .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    @IBOutlet weak var sendLinkOutlet: UIButton!
    
    @IBAction func sendLinkButton(_ sender: Any) {
        
        if let email = emailTextField.text {
            emailTextField.resignFirstResponder()
            Authenticate.instance.send_password_reset_link(email: email, success: {
                print("email send successfull")
                let alert = UIAlertController(title: "Success", message: "Email Send!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (err) in
                    self.performSegue(withIdentifier: "forgot_password_to_main", sender: self)
                }))
                self.present(alert, animated: true)
            }) {
                print("Could not send email. Make sure email is valid")
                let alert = UIAlertController(title: "Error", message: "Could not send email. Make sure email is valid", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to change view when keyboard appeards
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        emailTextField.delegate = self
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: " Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        sendLinkOutlet.customize_button()
        let attributeString = NSMutableAttributedString(string: "Sign up!",
                                                        attributes: yourAttributes)
        signUpButton.setAttributedTitle(attributeString, for: .normal)
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // touched anywhere on screen begain
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // touched anywhere on screen ended
        self.view.endEditing(true)
    }
    
    // objective-c function for when keyboard appears
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -(self.view.frame.width * 0.22)
    }
    
    // objective-c function for when keyboard disappear
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    // when hitting enter on the textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendLinkButton(self)
        return true
    }
}
