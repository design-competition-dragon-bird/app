//
//  HamburgerMenuViewController.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/31/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit



class HamburgerMenuViewController: UIViewController {

    var viewWidth: CGFloat!
    

    @IBOutlet weak var menu_view: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        viewWidth = self.view.bounds.width * 0.65
        menu_view.frame = CGRect(x: -viewWidth, y: 0, width: viewWidth, height: self.view.bounds.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate_main_view()
    }
    

    private func animate_main_view(){
        UIView.animate(withDuration: 0.3) {
            self.menu_view.frame.origin.x += self.viewWidth
        }
    }
    
    // when touched anywhere on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // do nothing
        if touches.first!.view != menu_view{
            exit_hamburger_menu()
            
            global_dispatchGroup.notify(queue: .main) {
                let storyboard = UIStoryboard(name: "tabBar", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "tab_bar_controller")
                self.present(viewController, animated: false, completion: nil)
            }
        }
    }
    
    private func exit_hamburger_menu(){
        global_dispatchGroup.enter()
        run {
            UIView.animate(withDuration: 0.3, animations: {
                self.menu_view.frame.origin.x -= self.viewWidth
            }, completion: { (didFinish) in
                global_dispatchGroup.leave()
            })
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // do nothing
    }
}
