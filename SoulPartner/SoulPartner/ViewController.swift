//
//  ViewController.swift
//  SoulPartner
//
//  Created by Saikiran Komatineni on 5/24/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var forgotButton_outlet: UIButton!
    @IBOutlet weak var passwordButton_outlet: UIButton!
    @IBOutlet weak var logInButton_outlet: UIButton!
    
    let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 18),
        .foregroundColor: UIColor.white,
        .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    @IBAction func forgotButton_action(_ sender: Any) {
        
    }
    @IBAction func passwordButton_action(_ sender: Any) {
        
    }
    @IBAction func loginButton_action(_ sender: Any) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Authenticate.instance.authenticate_user_login(email: email, passWord: password, success: {
                // perform segue
            }) {
                // show error
                print("failed login...")
                let alert = UIAlertController(title: "Error", message: "Incorrect email or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            }
        }
        else{
            print("Email or Password Text Field Cannot be empty!!!....")
            let alert = UIAlertController(title: "Error", message: "Email or Password Text Field Cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to change view when keyboard appeards
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name:UIResponder.keyboardWillHideNotification, object: nil)

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        passwordButton_outlet.customize_button()
        logInButton_outlet.customize_button()
        
        let attributeString = NSMutableAttributedString(string: "Forgot Password?",
                                                        attributes: yourAttributes)
        forgotButton_outlet.setAttributedTitle(attributeString, for: .normal)
        forgotButton_outlet.backgroundColor = .clear
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: " Email",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: " Password",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
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
        if textField == passwordTextField{
            loginButton_action(self)
        }
        else if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        return true
    }

}

extension UITextField{
    
    override open func draw(_ rect: CGRect){
        let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let path = UIBezierPath()
        
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = 4.0
        
        tintColor = UIColor.white
        tintColor.setStroke()
        
        path.stroke()
        textColor = UIColor.white
        borderStyle = .none
    }
}

extension UIButton{
    func customize_button(){
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.backgroundColor = UIColor(red: (211/255), green: (136/255), blue: CGFloat(61/255), alpha: 1.0).cgColor
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 4.0
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowColor = UIColor(red: (61/255), green: (32/255), blue: CGFloat(43/255), alpha: 1.0).cgColor
    }
}
