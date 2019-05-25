//
//  PatternsViewController.swift
//  SoulPartner
//
//  Created by Po Hsiang Huang on 5/25/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit
import Firebase

class PatternsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let db = Firestore.firestore()
    let PatternArray = ["Spring", "Summer", "Autumn", "Winter", "Custom"]
    
    @IBOutlet weak var patternsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        patternsTableView.dataSource = self
        patternsTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var pattern:String = ""
        db.collection("User/\(User.instance.userId)/PressurePoints").document(User.instance.selectedButton).getDocument { (snapshot, err) in
            if let data = snapshot?.data() {
                if data["pattern"] != nil {
                    pattern = data["pattern"] as! String
                    if (pattern != "") {
                        let row = self.PatternArray.firstIndex(of: pattern)!
                        let indexPath = IndexPath(row: row, section: 0)
                        self.patternsTableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
                    }
                }
            } else {
                print("Pressure point not set")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PatternArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatternsTableViewCell") as! PatternsTableViewCell
        let pattern = PatternArray[indexPath.row]
        cell.PatternCell.text = pattern
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setData(point: User.instance.selectedButton, pattern: PatternArray[indexPath.row])
        
        for row in 0..<PatternArray.count {
            let iterateIndexPath = IndexPath(row: row, section:0)
            tableView.cellForRow(at: iterateIndexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        
        if(indexPath.row == PatternArray.count-1) {
            performSegue(withIdentifier: "CustomPattern", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func setData(point: String, pattern: String) {
        db.collection("User/\(User.instance.userId)/PressurePoints").document(point).setData(["pattern": pattern]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    @IBAction func back(_ sender: Any) {
        
    }
    
}
