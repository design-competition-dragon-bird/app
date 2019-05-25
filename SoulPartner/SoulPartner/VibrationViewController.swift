//
//  VibrationViewController.swift
//  SoulPartner
//
//  Created by Po Hsiang Huang on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit

class VibrationViewController: UIViewController {
    var selected_button: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        User.instance.selectedButton = selected_button
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
    

}