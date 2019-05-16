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

    @IBOutlet weak var sceneView: SCNView!
    
    @IBAction func undoButton(_ sender: Any) {

    }
    @IBAction func rotateButton(_ sender: Any) {
       let rotateOne = SCNAction.rotateBy(x: 1, y: 0, z: 1, duration: 0.5)
        sceneView.scene?.rootNode.runAction(rotateOne)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup()
        // Do any additional setup after loading the view.
        let action = SCNAction.moveBy(x: 0, y: 2, z: 0, duration: 1)
        sceneView.scene?.rootNode.runAction(action)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let action = SCNAction.moveBy(x: 0, y: -20, z: 0, duration: 1)
        sceneView.scene?.rootNode.runAction(action)
    }

    func setup() {
        //        let sceneView = SCNView(frame: self.view.frame)
        //        self.view.addSubview(sceneView)
        //
        //        let scene = SCNScene(named: "shoe.scn")
        //        sceneView.scene = scene
    }

}

