//
//  tabBarViewController.swift
//  SoulPartner
//
//  Created by Saikiran Komatineni on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Global variables for tab bar control
enum TAB_BAR:Int{
    case VIBRATION_PAGE = 0
    case GATE_PAGE = 1
    case MODEL_3D_PAGE = 2
}

var current_tab = TAB_BAR.MODEL_3D_PAGE.rawValue

let tab_bar_color = [
    UIColor(red: (0xff/255), green: (0xaa/255), blue: (0x00/255), alpha: 1),
    UIColor(red: (98/255), green: (211/255), blue: (68/255), alpha: 1),
    UIColor(red: (69/255), green: (28/255), blue: (37/255), alpha: 1)
]

let tab_bar_titles = ["Vibration", "Gait", "3D Model"]

let tab_bar_selected_image = [
    UIImage(named: "vibration_tab copy")?.withRenderingMode(.alwaysOriginal),
    UIImage(named: "right_sole_icon_tab")?.withRenderingMode(.alwaysOriginal),
    UIImage(named: "shoe_tab")?.withRenderingMode(.alwaysOriginal)
]

let tab_bar_deselected_image = [
    UIImage(named: "vibration_tab copy")?.withRenderingMode(.alwaysOriginal),
    UIImage(named: "right_sole_icon_tab")?.withRenderingMode(.alwaysOriginal),
    UIImage(named: "shoe_tab")?.withRenderingMode(.alwaysOriginal)
]

class tabBarViewController: UITabBarController, Observer {
    
    func update(value: [Character : String]) {
        // do something
        print("value = ", value)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)  // title color when item is selected
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], for: .normal)   // title color when item is not selected
     
        customize_tab_bar()
        
//        Parse.instance.attachObserver(observer: self)
        
        self.selectedIndex = current_tab
        self.tabBar.barTintColor = tab_bar_color[self.selectedIndex]
        self.tabBar.items![selectedIndex].title = tab_bar_titles[self.selectedIndex]
        
    }
    
    private func customize_tab_bar(){
        for i in 0..<self.tabBar.items!.count{
            self.tabBar.items![i].title = nil
            self.tabBar.items![i].image = tab_bar_deselected_image[i]
            self.tabBar.items![i].selectedImage = tab_bar_selected_image[i]
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        self.tabBar.barTintColor = tab_bar_color[tabBarIndex]
    }
    
    // changing color when different tab bar is selected
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        for i in 0..<self.tabBar.items!.count{
            if item == self.tabBar.items![i]{
                item.title = tab_bar_titles[i]
                self.tabBar.barTintColor = tab_bar_color[i]
            }
            else{
                self.tabBar.items![i].title = nil
                self.tabBar.items![i].imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
}

extension UIImage{
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage{
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
