//
//  ObserverPattern.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import Foundation

protocol Observer {
    func update(value: [Character: String])
}

protocol BT_Connection_Observer{
    func update(value: String)
}
