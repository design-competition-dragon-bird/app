//
//  PatternsViewController.swift
//  Vibration
//
//  Created by Po Hsiang Huang on 5/24/19.
//  Copyright © 2019 Po Hsiang Huang. All rights reserved.
//

import UIKit
import Firebase

class PatternsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let db = Firestore.firestore()
    var PressurePoint: String!
    let PatternArray = ["Spring", "Summer", "Autumn", "Winter", "Custom"]

    @IBOutlet weak var patternsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        patternsTableView.dataSource = self
        patternsTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var pattern:String = ""
        db.collection("PressurePoints").document(Vibration_Info.button_info.button).getDocument { (snapshot, err) in
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
        cell.patternCell.text = pattern
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setData(point: Vibration_Info.button_info.button, pattern: PatternArray[indexPath.row])
        
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

    func findData(point: String) {
        db.collection("PressurePoints").document("point").getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func setData(point: String, pattern: String) {
        db.collection("PressurePoints").document(point).setData(["pattern": pattern]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }

}
