//
//  HeatMapViewController.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit

class HeatMapViewController: UIViewController, Observer {
    
    @IBOutlet weak var spectrum_view: UIView!
    
    var spectrum_view2: UIView!
    
    func update(value: [Character : String]) {
        // do nothing
    }
    @IBOutlet weak var right_sole_icone: UIImageView!
    
    var heatMap: HeatMap!
    override func viewDidLoad() {
        super.viewDidLoad()

        heatMap = HeatMap()
        right_sole_icone.image = heatMap.right_sole_icon
        
        spectrum_view2 = UIView(frame: CGRect(x: right_sole_icone.frame.minX, y: right_sole_icone.frame.maxY + 10, width: self.view.bounds.width * 0.8, height: self.view.bounds.height * 0.2))
        self.view.addSubview(spectrum_view2)
        generateSpectrum()
    }
    

    func generateSpectrum(){
        let count = 100
        let p0 = Point_3D(x: 1, y: 0, z: 0)
        let p1 = Point_3D(x: 0, y: 1, z: 0)
        let p2 = Point_3D(x: 0, y: 0, z: 1)
        let height = spectrum_view.frame.height
        let width = spectrum_view.frame.width
        let start_y = spectrum_view.frame.minY
        let temp_width = width / CGFloat(count)
        
        for i in 0..<count{
            let start_x = width * (CGFloat(i) / CGFloat(count))
            let color = heatMap.get_color_from_pressure_data(p0: p0, p1: p1, p2: p2, t: CGFloat(i) / CGFloat(count))
            let frame = CGRect(x: start_x, y: start_y, width: temp_width, height: height)
            let temp_view = UIView(frame: frame)
            temp_view.backgroundColor = UIColor(red: color.x, green: color.y, blue: color.z, alpha: 1)

            spectrum_view2.addSubview(temp_view)

        }
        
    }

}
