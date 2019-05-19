//
//  VibrationViewController.swift
//  Vibration
//
//  Created by Po Hsiang Huang on 5/3/19.
//  Copyright © 2019 Po Hsiang Huang. All rights reserved.
//

import UIKit
import Firebase

class VibrationViewController: UIViewController {
    
    @IBOutlet weak var PressurePointView: UIView!
    var selected_button: String!
    var vibration_info: Vibration_Info = Vibration_Info()
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func PP1(_ sender: Any) {
        selected_button = "PP1"
        self.performSegue(withIdentifier: "SettingSegue", sender: nil)
    }
    @IBAction func PP2(_ sender: Any) {
        selected_button = "PP2"
        self.performSegue(withIdentifier: "SettingSegue", sender: nil)
    }
    @IBAction func PP3(_ sender: Any) {
        selected_button = "PP3"
        self.performSegue(withIdentifier: "SettingSegue", sender: nil)
    }
    @IBAction func PP4(_ sender: Any) {
        selected_button = "PP4"
        self.performSegue(withIdentifier: "SettingSegue", sender: nil)
    }
    @IBAction func PP5(_ sender: Any) {
        selected_button = "PP5"
        self.performSegue(withIdentifier: "SettingSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vibration_setting = segue.destination as! PatternTableViewController
        vibration_setting.PressurePoint = selected_button
    }
    
}
