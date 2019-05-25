//
//  heatMap2.0.swift
//  HeatMap
//
//  Created by Ravi Patel on 5/18/19.
//  Copyright © 2019 Design Comeptition. All rights reserved.
//

import UIKit
import CoreGraphics

class HeatMap_2_0: UIViewController{
    
    @IBOutlet weak var right_sole_icon: UIImageView!
    
    var heatMap: HeatMap!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        heatMap = HeatMap()
        
        right_sole_icon.image = heatMap.right_sole_icon
        
        print("done!!")
    }
    
   
}
