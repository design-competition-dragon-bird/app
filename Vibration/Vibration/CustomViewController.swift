//
//  CustomViewController.swift
//  Vibration
//
//  Created by Po Hsiang Huang on 5/18/19.
//  Copyright © 2019 Po Hsiang Huang. All rights reserved.
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
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var tapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapCounts = Array(repeating: false, count: self.maxTime)
        if(time==maxTime) {tapButton.isEnabled = false}
        CustomRef = self.db.collection("Pattern").document("DpfW6iqZKwdeUF7V96lr")
    }
    
    @IBAction func back(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func selectPattern(_ sender: Any) {
        CustomRef.updateData(["CustomPattern": FieldValue.delete()])
        CustomRef.updateData(["CustomPattern": FieldValue.arrayUnion(tapCounts)])
        _ = navigationController?.popViewController(animated: true)
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
    }
    
    @objc func action() {
        time += 1
    }

}
