//
//  Vibration_Info.swift
//  SoulPartner
//
//  Created by Po Hsiang Huang on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import Foundation
import Firebase

class Vibration_Info{
    
    static let button_info = Vibration_Info()
    
    var button: String!
    var pattern: String!
    init() {
        button = "default button"
        pattern = "default pattern"
    }
    
}
