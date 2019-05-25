//
//  BTViewController.swift
//  SoulPartner
//
//  Created by Saikiran Komatineni on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit
import Lottie

class BTViewController: UIViewController {

    var lottie_animation: AnimationView!
    @IBAction func multiPurposeButtonAction(_ sender: Any) {
        
    }
    
    var bt_interface: BluetoothInterface!
    @IBOutlet weak var multipurposeButton_outlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        let ratio: CGFloat = 0.5
        let origin = CGPoint(x: width * (ratio - 0.1) / 2, y: height * ratio / 3)
        
        bt_interface = BluetoothInterface()
        multipurposeButton_outlet.customize_button()
        
        // for lottie animations
        lottie_animation = AnimationView(name: "bluetooth_animation")
        lottie_animation.frame = CGRect(origin: origin, size: CGSize(width: width * (ratio + 0.1), height: height * ratio))
        self.view.addSubview(lottie_animation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playAnimation()
    }
    
    func playAnimation(){
        lottie_animation.contentMode = .scaleAspectFill
        lottie_animation.loopMode = .loop
        lottie_animation.play()
    }
}
