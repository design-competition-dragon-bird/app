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
            
            DispatchQueue.main.async {
                if let data = value["P"] {
                    let dataArray = data.components(separatedBy: " ")
                    var intArray = [Int]()
                    for i in dataArray {
                        intArray.append(Int(i) as! Int)
                    }
                    //            print("float Array", intArray)
                    
                    //update the pressure_data 2D matrix in heatmap
                    var pressureData = [[Int]](repeating: [Int](repeating: 0, count: 5), count: 14)
                    var counter: Double = 0
                    
                    for j in 0..<num_Rows {
                        for i in 0..<num_Cols {
                            pressureData[j][i] = intArray[j*5 + i]
                            counter += 1
                        }
                    }
                    
                self.right_sole_icone.image = self.heatMap.updateHeatMap(pressureData: pressureData)
                self.right_sole_icone.setNeedsDisplay()
                    User.instance.storePressureData(intArray: intArray, success: {
                        // success
                        // do nothing for now
                        print("Heatmap data saved successfully")
                    }, failure: {
                        // failure
                        // do nothing for now
                        print("Unable to save heatmap data...")
                    })
            }
            
        }
        // do nothing
    }
    
    @IBOutlet weak var right_sole_icone: UIImageView!
    var parser: Parse!
    
    var view_array = [UIView]()
    var heatMap: HeatMap!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parser = Parse()
        parser.attachObserver(observer: self)
        
        heatMap = HeatMap()
        right_sole_icone.image = heatMap.right_sole_icon
        
        for _ in 0..<count{
            view_array.append(UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1)))
        }

        generateSpectrum()
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
