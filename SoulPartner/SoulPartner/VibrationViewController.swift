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
    
    @IBAction func message_button_clicked(_ sender: Any) {
        current_tab = TAB_BAR.VIBRATION_PAGE.rawValue
//        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "messages_navigation_controller")
//        self.present(viewController, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "History", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "historyTabBar")
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    @IBAction func hamburger_menu_clicked(_ sender: Any) {
        current_tab = TAB_BAR.VIBRATION_PAGE.rawValue
        let storyboard = UIStoryboard(name: "tabBar", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "hamburger_view_controller")
        self.present(viewController, animated: true, completion: nil)
    }
    
    
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
