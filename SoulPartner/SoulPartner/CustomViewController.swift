//
//  CustomViewController.swift
//  SoulPartner
//
//  Created by Po Hsiang Huang on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit
import Firebase

class CustomViewController: UIViewController {
    let db = Firestore.firestore()
    let maxTime = 100
    var CustomRef: DocumentReference!
    var time = 0
    var timer = Timer()
    var tapCounts: Array<Bool>!
    var tapped = false
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var tapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapCounts = Array(repeating: false, count: self.maxTime)
        if(time==maxTime) {tapButton.isEnabled = false}
//        CustomRef = self.db.collection("User/\(User.instance.userId)/PressurePoints").document("Custom")
    }
    
    @IBAction func selectPattern(_ sender: Any) {
        if(tapped == true) {
            db.collection("User/\(User.instance.userId)/PressurePoints").document("Custom").setData(["CustomPattern": tapCounts!]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        self.performSegue(withIdentifier: "back_to_vibration_pattern", sender: self)
    }
    
    @IBAction func replay(_ sender: Any) {
        startLabel.isHidden = false
        time = 0
        tapButton.isEnabled = true
        dump(tapCounts)
    }
    
    @IBAction func tap(_ sender: Any) {
        startLabel.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(CustomViewController.action), userInfo: nil, repeats: true)
        var i = 0
        while((time+i<maxTime)&&(i<5)) {
            tapCounts[time+i] = true
            i+=1
        }
        tapped = true
        print("tapped")
    }
    
    @objc func action() {
        time += 1
    }
    
}
