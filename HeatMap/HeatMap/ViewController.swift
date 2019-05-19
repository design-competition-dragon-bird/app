//
//  ViewController.swift
//  HeatMap
//
//  Created by Ravi Patel on 4/20/19.
//  Copyright © 2019 Design Comeptition. All rights reserved.
//

import UIKit

struct Point_3D{
    var x:CGFloat
    var y:CGFloat
    var z:CGFloat
}

class ViewController: UIViewController {

    @IBOutlet weak var custom_view: UIView!
    
    var t: CGFloat = 0
    var count = 0
    let num_of_increment = 1000
    var color: Point_3D!
    var p0: Point_3D!
    var p1: Point_3D!
    var p2: Point_3D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        color = Point_3D(x: 0, y: 0, z: 0)
        p0 = Point_3D(x: 0, y: 0, z: 1)
        p1 = Point_3D(x: 0, y: 1, z: 0)
        p2 = Point_3D(x: 1, y: 0, z: 0)
        
        custom_view.backgroundColor = UIColor.blue

        // create a new UIView and add it to the view controller
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        let myView = CustomView()
        myView.frame = CGRect(x: 0, y: height * 0.35, width: width, height: height * 0.3)
        myView.backgroundColor = UIColor.yellow
//        view.addSubview(myView)
    }
    
    // linear bezier path: (1-t)p0 + tp1
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        show_spectrum()
//        show_spectrum2()
        show_spectrum3()
//        show_spectrum4()
        sleep(1)
        
//        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { (timer) in
//            if self.count <= self.num_of_increment {
//                print("t = ", self.t)
//                print("color = ", self.color!)
//                self.color = self.quadratic_bezier2(p0: self.p0, p1: self.p1, p2: self.p2, t: self.t)
//                self.custom_view.backgroundColor = UIColor(red: self.color.x, green: self.color.y, blue: self.color.z, alpha: 1)
//
//                self.count = self.count + 1
//                self.t = CGFloat(self.count) / CGFloat(self.num_of_increment)
//            }
//            else{
//                print("terminatint timer...")
//                timer.invalidate()
//            }
//
//        }
        
    }
    
    // quadratic bezier path: (1 - t)^2p0 + 2t(1-t)p1 + t^2p2;  0<=u<=1
    func quadratic_bezier(p0: Point_3D, p1: Point_3D, p2: Point_3D, t: CGFloat) -> Point_3D{
        var pFinal = Point_3D(x: 0, y: 0, z: 0)
        
        pFinal.x = pow((1-t), 2) * p0.x + 2 * t * (1-t) * p1.x + pow(t, 2) * p2.x
        pFinal.y = pow((1-t), 2) * p0.y + 2 * t * (1-t) * p1.y + pow(t, 2) * p2.y
        pFinal.z = pow((1-t), 2) * p0.z + 2 * t * (1-t) * p1.z + pow(t, 2) * p2.z

        return pFinal
    }
    
    func quadratic_bezier2(p0: Point_3D, p1: Point_3D, p2: Point_3D, t: CGFloat) -> Point_3D{
        var pFinal = Point_3D(x: 0, y: 0, z: 0)
        
        pFinal.x = pow((1-t), 2) * p0.x + 4 * t * (1-t) * p1.x + pow(t, 2) * p2.x
        pFinal.y = pow((1-t), 2) * p0.y + 4 * t * (1-t) * p1.y + pow(t, 2) * p2.y
        pFinal.z = pow((1-t), 2) * p0.z + 4 * t * (1-t) * p1.z + pow(t, 2) * p2.z
        
        return pFinal
    }
    
    func quadratic_bezier3(p0: Point_3D, p1: Point_3D, p2: Point_3D, t: CGFloat) -> Point_3D{
        var pFinal = Point_3D(x: 0, y: 0, z: 0)
        
//        pFinal.x = sqrt(t)
        pFinal.y = -4 * pow(t - 0.5, 2) + 1
//        pFinal.z = -pow(t, 2) + 1
        
        pFinal.x = cos(t)
        pFinal.z = sin(t)
        
        return pFinal
    }
    
    func gamma_correction(p0: Point_3D, gamma: CGFloat = 1) -> Point_3D{
        var pFinal = Point_3D(x: 0, y: 0, z: 0)
        
        pFinal.x = pow(p0.x, gamma)
        pFinal.y = pow(p0.y, gamma)
        pFinal.z = pow(p0.z, gamma)

        return pFinal
    }
    
    func show_spectrum() {
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let start_x = 0
        let start_y = height * 0.05
        let individual_width = width / CGFloat(num_of_increment)
        let individual_height = height * 0.1
        
        for i in 0...num_of_increment {
            
            let x = CGFloat(start_x) + (individual_width * CGFloat(i))
            let new_t = CGFloat(i) / CGFloat(num_of_increment)
            let frame = CGRect(x: x, y: start_y, width: individual_width, height: individual_height)
            
            let new_view = UIView(frame: frame)
            let new_color = quadratic_bezier(p0: self.p0, p1: self.p1, p2: self.p2, t: new_t)
            
            new_view.backgroundColor = UIColor(red: new_color.x, green: new_color.y, blue: new_color.z, alpha: 1)
            
            self.view.addSubview(new_view)
        }
    }
    
    func show_spectrum2() {
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let start_x = 0
        let start_y = height * 0.17
        let individual_width = width / CGFloat(num_of_increment)
        let individual_height = height * 0.1
        
        for i in 0...num_of_increment {
            
            let x = CGFloat(start_x) + (individual_width * CGFloat(i))
            let new_t = CGFloat(i) / CGFloat(num_of_increment)
            let frame = CGRect(x: x, y: start_y, width: individual_width, height: individual_height)
            
            let new_view = UIView(frame: frame)
            let new_color = quadratic_bezier2(p0: self.p0, p1: self.p1, p2: self.p2, t: new_t)
            
            new_view.backgroundColor = UIColor(red: new_color.x, green: new_color.y, blue: new_color.z, alpha: 1)
            
            self.view.addSubview(new_view)
        }
    }
    
    func show_spectrum3() {
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let start_x = 0
        let start_y = height * 0.29
        let individual_width = width / CGFloat(num_of_increment)
        let individual_height = height * 0.1
        
        for i in 0...num_of_increment {
            
            let x = CGFloat(start_x) + (individual_width * CGFloat(i))
            let new_t = CGFloat(i) / CGFloat(num_of_increment)
            let frame = CGRect(x: x, y: start_y, width: individual_width, height: individual_height)
            
            let new_view = UIView(frame: frame)
            let new_color = quadratic_bezier3(p0: self.p0, p1: self.p1, p2: self.p2, t: new_t)
            
            new_view.backgroundColor = UIColor(red: new_color.x, green: new_color.y, blue: new_color.z, alpha: 1)
            
            self.view.addSubview(new_view)
        }
    }
    
    func show_spectrum4() {
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let start_x = 0
        let start_y = height * 0.6
        let individual_width = width / CGFloat(num_of_increment)
        let individual_height = height * 0.1
        
        for i in 0...num_of_increment {
            
            let x = CGFloat(start_x) + (individual_width * CGFloat(i))
            let new_t = CGFloat(i) / CGFloat(num_of_increment)
            let frame = CGRect(x: x, y: start_y, width: individual_width, height: individual_height)
            
            let new_view = UIView(frame: frame)
            let new_color = gamma_correction(p0: quadratic_bezier(p0: self.p0, p1: self.p1, p2: self.p2, t: new_t), gamma: 0.7)
            
            new_view.backgroundColor = UIColor(red: new_color.x, green: new_color.y, blue: new_color.z, alpha: 1)
            
            self.view.addSubview(new_view)
        }
    }
}

