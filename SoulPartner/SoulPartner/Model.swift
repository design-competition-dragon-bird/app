//
//  Model.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit
import SceneKit

class MotionModelScene: SCNView {
    private var shoeNode : SCNNode?
    
    func start() {
        shoeNode = scene?.rootNode.childNode(withName: "shoe", recursively: false)
    }
    
    //    func setThingyQuaternion(x: Float, y: Float, z: Float, w: Float, andUpdateInterval interval: TimeInterval) {
    //        //Due to 3D model and hardware differences, the following changes are needed for proper presentation:
    //        //X => Y
    //        //Y => -Z
    //        //Z => -X
    //        SCNTransaction.animationDuration = interval
    //        let quaternion = SCNQuaternion(y, -z, -x, w)
    //        shoeNode?.orientation = quaternion
    //    }
}
