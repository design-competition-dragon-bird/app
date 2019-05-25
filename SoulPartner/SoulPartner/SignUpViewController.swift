//
//  SignUpViewController.swift
//  SoulPartner
//
//  Created by Saikiran Komatineni on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let pickerData = ["Care Giver", "Patient", "Doctor"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = pickerData[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    

    @IBOutlet weak var signUpButton_outlet: UIButton!
    @IBAction func signUpButton_action(_ sender: Any) {
    }
    @IBOutlet weak var picker_outlet: UIPickerView!
    @IBOutlet weak var password_textField: UITextField!
    @IBOutlet weak var email_textField: UITextField!
    @IBOutlet weak var phoneNumber_textField: UITextField!
    @IBOutlet weak var lastName_textField: UITextField!
    @IBOutlet weak var firstName_textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to change view when keyboard appeards
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        self.picker_outlet.delegate = self
        self.picker_outlet.dataSource = self
        
        self.password_textField.delegate = self
        self.email_textField.delegate = self
        self.phoneNumber_textField.delegate = self
        self.lastName_textField.delegate = self
        self.firstName_textField.delegate = self
        
        
        password_textField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        email_textField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        phoneNumber_textField.attributedPlaceholder = NSAttributedString(string: "Phone",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        lastName_textField.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        firstName_textField.attributedPlaceholder = NSAttributedString(string: "Fast Name",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        signUpButton_outlet.customize_button()
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
        self.view.frame.origin.y = -(self.view.frame.height * 0.22)
    }
    
    // objective-c function for when keyboard disappear
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    // when hitting enter on the textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstName_textField{
            lastName_textField.becomeFirstResponder()
        }
        else if textField == lastName_textField{
            phoneNumber_textField.becomeFirstResponder()
        }
        else if textField == phoneNumber_textField{
            email_textField.becomeFirstResponder()
        }
        else if textField == email_textField{
            password_textField.becomeFirstResponder()
        }
        else if textField == password_textField{
            signUpButton_action(self)
        }
        return true
    }
}
