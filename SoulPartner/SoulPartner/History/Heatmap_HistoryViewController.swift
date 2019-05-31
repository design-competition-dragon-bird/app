//
//  HeatmapViewController.swift
//  SoulPartner
//
//  Created by Saikiran Komatineni on 5/31/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit

class Heatmap_HistoryViewController: UIViewController {

    @IBAction func sliderAction(_ sender: Any) {
        print("slider Value: ", sliderOutlet.value)
    }
    
    @IBOutlet weak var sliderOutlet: UISlider!
    @IBOutlet weak var heatMapImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}
