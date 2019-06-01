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
        DispatchQueue.main.async {
            var pressureData = [[Int]](repeating: [Int](repeating: 0, count: num_Cols), count: num_Rows)
            var counter: Double = 0
            
            for j in 0..<num_Rows {
                for i in 0..<num_Cols {
                    pressureData[j][i] = self.pressure_history[Int(self.sliderOutlet.value)][j*5 + i]
                    counter += 1
                }
            }
            self.heatMapImageView.image = HeatMap.instance.updateHeatMap(pressureData: pressureData)
            self.heatMapImageView.setNeedsDisplay()
        }
    }
    
    @IBOutlet weak var sliderOutlet: UISlider!
    @IBOutlet weak var heatMapImageView: UIImageView!
    
    var pressure_history = [[Int]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.instance.getPressureData(success: { (pressureData) in
            // success
            print("Heatmap data retieved successfully: ")
//            print(pressureData)
            self.pressure_history = pressureData
            self.sliderOutlet.value = 0
            self.sliderOutlet.minimumValue = 0
            self.sliderOutlet.maximumValue = Float(pressureData.count) - 1
            var pressureData = [[Int]](repeating: [Int](repeating: 0, count: num_Cols), count: num_Rows)
            var counter: Double = 0
            
            for j in 0..<num_Rows {
                for i in 0..<num_Cols {
                    pressureData[j][i] = self.pressure_history[0][j*5 + i]
                    counter += 1
                }
            }
            self.heatMapImageView.image = HeatMap.instance.updateHeatMap(pressureData: pressureData)
            self.heatMapImageView.setNeedsDisplay()
        }) {
            // failure
            print("Unable to retrieve heatmap data...")

        }
        print("view did load for History Heatmap")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func play_button_clicked(_ sender: Any) {
        self.sliderOutlet.value = 0
        for i in 0...Int(self.sliderOutlet.maximumValue){
            self.sliderOutlet.value = Float(i)
            self.sliderAction(self)
        }
    }
    

}
