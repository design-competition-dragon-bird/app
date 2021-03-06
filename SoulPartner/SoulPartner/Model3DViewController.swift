//
//  Model3DViewController.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit
import SceneKit

class Model3DViewController: UIViewController, Observer {
    
    @IBAction func message_button_clicked(_ sender: Any) {
        current_tab = TAB_BAR.MODEL_3D_PAGE.rawValue
        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "messages_navigation_controller")
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    @IBAction func hamburger_menu_clicked(_ sender: Any) {
        current_tab = TAB_BAR.MODEL_3D_PAGE.rawValue
        let storyboard = UIStoryboard(name: "tabBar", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "hamburger_view_controller")
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    func update(value: [Character : String]) {
//        print("update in gyro stuff")
        if let data = value["G"] {
            var dataArray = data.components(separatedBy: " ")
            var floatArray = [Float]()
            for i in dataArray {
                floatArray.append(Float(i) as! Float)
            }
//            print("float Array", floatArray)
            
            let pitch = floatArray[1]
            let roll = floatArray[2]
            let yaw = floatArray[0]
            
            sceneView.scene?.rootNode.isPaused = false
            let rotateOne = SCNAction.rotateBy(x: CGFloat(pitch - self.pitch), y: CGFloat(yaw - self.yaw), z: CGFloat(roll - self.roll), duration: 0.5)
            shoeNode?.runAction(rotateOne)
            
            print("angles: ", pitch - self.pitch, "  ", yaw - self.yaw, "  ", roll - self.roll)
            
            self.pitch = pitch
            self.roll = roll
            self.yaw = yaw
            
//            User.instance.storeGyroData(pitch: pitch, roll: roll, yaw: yaw, success: {
//                // success
//                print("Gyro data save succesfully")
//            }) {
//                // failure
//                print("Unable to save gyro data...")
//            }
            
        }
    }
    
    private var pitch: Float = 0
    private var roll: Float = 0
    private var yaw: Float = 0
    
    private var shoeNode : SCNNode?

    @IBOutlet weak var sceneView: SCNView!
    
    var parser: Parse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shoeNode = sceneView.scene?.rootNode.childNode(withName: "shoe", recursively: false)
        // Do any additional setup after loading the view.
        parser = Parse()
        parser.attachObserver(observer: self)
        
        print("view did load of 3D model......")
        
        
        
    }
}
