//
//  HeatMapViewController.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit

class HeatMapViewController: UIViewController, Observer {
    
    let count = 100

    @IBOutlet weak var spectrum_view: UIView!
    
    func update(value: [Character : String]) {
        // do nothing
    }
    @IBOutlet weak var right_sole_icone: UIImageView!
    
    var view_array = [UIView]()
    var heatMap: HeatMap!
    override func viewDidLoad() {
        super.viewDidLoad()

        heatMap = HeatMap()
        right_sole_icone.image = heatMap.right_sole_icon
        
        for _ in 0..<count{
            view_array.append(UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1)))
        }

        generateSpectrum()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
//        heatMap.randomize_data()
//        right_sole_icone.image = heatMap.right_sole_icon
    }

    func generateSpectrum(){
        
        let p0 = Point_3D(x: 1, y: 0, z: 0)
        let p1 = Point_3D(x: 0, y: 1, z: 0)
        let p2 = Point_3D(x: 0, y: 0, z: 1)
        let height = spectrum_view.frame.height
        let width = spectrum_view.frame.width
        let min_x = spectrum_view.frame.minX
        let start_y = spectrum_view.frame.minY
        let temp_width = width / CGFloat(count)
        
        for i in 0..<count{
            let start_x = width * (CGFloat(i) / CGFloat(count)) + min_x
            let color = heatMap.get_color_from_pressure_data(p0: p0, p1: p1, p2: p2, t: CGFloat(i) / CGFloat(count))
            let frame = CGRect(x: start_x, y: start_y, width: temp_width, height: height)
            let uiColor = UIColor(red: color.x, green: color.y, blue: color.z, alpha: 1)
            view_array[i].frame = frame
            view_array[i].backgroundColor = uiColor
            self.view.addSubview(view_array[i])

        }
        
    }

}
