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
    
    func update(value: [Character : String]) {
        // do nothing
        
        
        pitch = 2
        roll = 2
        yawn = 2
        
        sceneView.scene?.rootNode.isPaused = false
        let rotateOne = SCNAction.rotateBy(x: CGFloat(pitch - self.pitch), y: CGFloat(yawn - self.yawn), z: CGFloat(roll - self.roll), duration: 1.5)
        shoeNode?.runAction(rotateOne)
        
        self.pitch += pitch
        self.roll += roll
        self.yawn += yawn
    }
    
    private var pitch = 0
    private var roll = 0
    private var yawn = 0
    
    private var shoeNode : SCNNode?
    
    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         shoeNode = sceneView.scene?.rootNode.childNode(withName: "shoe", recursively: false)
        sceneView.scene?.rootNode.isPaused = false
        
//        print(sceneView.scene?.rootNode.simdRotation)
        
//        for i in 0...5 {
//            sceneView.scene?.rootNode.isPaused = false
//            let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat(i), z: 0, duration: 1.5) //pitch, yaw, roll
//            shoeNode?.runAction(rotateOne)
//        }
    }

}
