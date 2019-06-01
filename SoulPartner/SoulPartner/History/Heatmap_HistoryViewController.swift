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
//        User.instance.getPressureData(success: {
//            // success
//            // do nothing for now
//            print("Heatmap data retieved successfully")
//        }, failure: {
//            // failure
//            // do nothing for now
//            print("Unable to retrieve heatmap data...")
//        })
        // Do any additional setup after loading the view.
    }

}
