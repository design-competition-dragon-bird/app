//
//  MessagesTableViewController.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/31/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController {

    @IBAction func back_button_clicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "tabBar", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "tab_bar_controller")
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.view.backgroundColor = UIColor(red: 30/255, green: 27/255, blue: 47/255, alpha: 1)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message_cell", for: indexPath)

        cell.backgroundColor = UIColor(red: 30/255, green: 27/255, blue: 47/255, alpha: 1)
        // Configure the cell...

        return cell
    }
    

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "messages_view_controller")
//        self.present(viewController, animated: true, completion: nil)
//    }

}
