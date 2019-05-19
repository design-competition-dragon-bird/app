//
//  viabration_info.swift
//  HeatMap
//
//  Created by Ravi Patel on 5/3/19.
//  Copyright © 2019 Design Comeptition. All rights reserved.
//

import Foundation

enum VIABRATION_TYPE{
    case DEFAULT_1
    case DEFAULT_2
    case CUSTOM
}

class Viabration_Info{
    
    var button: String!
    var viabration_type: String!
    
    init(){
        button = nil
        viabration_type = nil
    }
}
