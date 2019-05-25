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
    }
    
    @IBAction func rotateButton(_ sender: Any) {
        sceneView.scene?.rootNode.isPaused = false
        let rotateOne = SCNAction.rotateBy(x: 1, y: 0, z: 0, duration: 0.5)
        shoeNode?.runAction(rotateOne)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
