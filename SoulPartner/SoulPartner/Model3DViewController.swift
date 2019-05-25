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
    
//    static let instance = Model3DViewController()
    
    func update(value: [Character : String]) {
        // do nothing
        print("update in gyro stuff")
        if let data = value["G"] {
            var dataArray = data.components(separatedBy: " ")
            var floatArray = [Float]()
            for i in dataArray {
                floatArray.append(Float(i) as! Float)
            }
            print(floatArray)
            
            var pitch = floatArray[1]
            var roll = floatArray[2]
            var yawn = floatArray[0]
            
            sceneView.scene?.rootNode.isPaused = false
            let rotateOne = SCNAction.rotateBy(x: CGFloat(pitch - self.pitch), y: CGFloat(yawn - self.yawn), z: CGFloat(roll - self.roll), duration: 1.5)
            shoeNode?.runAction(rotateOne)
            
            self.pitch += pitch
            self.roll += roll
            self.yawn += yawn
            
        }
    }
    
    private var pitch: Float = 0
    private var roll: Float = 0
    private var yawn: Float = 0
    
    private var shoeNode : SCNNode?
    var timer = Timer()

    @IBOutlet weak var sceneView: SCNView!
    
    var parser: Parse!
    var isDone: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//         shoeNode = sceneView.scene?.rootNode.childNode(withName: "shoe", recursively: false)
//        sceneView.scene?.rootNode.isPaused = false
        
        parser = Parse()
        parser.attachObserver(observer: self)
        
        
//        print(sceneView.scene?.rootNode.simdRotation)
        
//        for i in 0...5 {
//            sceneView.scene?.rootNode.isPaused = false
//            let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat(i), z: 0, duration: 1.5) //pitch, yaw, roll
//            shoeNode?.runAction(rotateOne)
//        }
        print("view did load of 3D model......")
        if Parse.instance.temp == true{
            isDone = true
            Parse.instance.temp = false
        }
        
        scheduledTimerWithTimeInterval()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shoeNode = sceneView.scene?.rootNode.childNode(withName: "shoe", recursively: false)
        sceneView.scene?.rootNode.isPaused = false
        
  
        
//        if isDone{
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "bt_interface_view_controller")
//            self.present(controller, animated: true, completion: nil)
//            isDone = false
//            addToObserver()
//        }
        
        
        
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        self.sceneView.scene?.rootNode.isPaused = false
        let rotateOne = SCNAction.rotateBy(x: 1, y: 0, z: 1, duration: 0.5)
        shoeNode?.runAction(rotateOne)
    }
    
    func addToObserver(){
        Parse.instance.attachObserver(observer: self)
        print("hello")
    }
}
