//
//  ViewController.swift
//  graphic_test
//
//  Created by Saikiran Komatineni on 4/29/19.
//  Copyright © 2019 design. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    private var shoeNode : SCNNode?
    
    @IBOutlet weak var sceneView: SCNView!
    
    @IBAction func undoButton(_ sender: Any) {

    }
    
    @IBAction func rotateButton(_ sender: Any) {
        sceneView.scene?.rootNode.isPaused = false
       let rotateOne = SCNAction.rotateBy(x: 1, y: 0, z: 0, duration: 0.5)
        shoeNode?.runAction(rotateOne)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        shoeNode = sceneView.scene?.rootNode.childNode(withName: "shoe", recursively: false)
    }

}

