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
}
