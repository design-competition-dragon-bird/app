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
    }
    

    private var shoeNode : SCNNode?
    
    @IBOutlet weak var sceneView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         shoeNode = sceneView.scene?.rootNode.childNode(withName: "shoe", recursively: false)
        for i in 0...5 {
            sceneView.scene?.rootNode.isPaused = false
            let rotateOne = SCNAction.rotateBy(x: CGFloat(i), y: 0, z: 0, duration: 0.5)
            shoeNode?.runAction(rotateOne)
        }
    }

}
