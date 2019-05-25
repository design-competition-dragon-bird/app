//
//  SignUpViewController.swift
//  SoulPartner
//
//  Created by Saikiran Komatineni on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBAction func backButton_action(_ sender: Any) {
    }
    let pickerData = ["Doctor", "Patient", "Care Giver"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = pickerData[component]
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
        self.picker_outlet.delegate = self
        self.picker_outlet.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
