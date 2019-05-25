//
//  HeatMapViewController.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit

class HeatMapViewController: UIViewController, Observer {
    
    func update(value: [Character : String]) {
        // do nothing
    }
    
    @IBOutlet weak var right_sole_icone: UIImageView!
    
    var heatMap: HeatMap!
    override func viewDidLoad() {
        super.viewDidLoad()

        heatMap = HeatMap()
        
        right_sole_icone.image = heatMap.right_sole_icon
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
