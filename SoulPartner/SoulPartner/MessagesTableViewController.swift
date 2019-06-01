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
    
    var chats_list = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        print("before...")
        self.view.backgroundColor = UIColor(red: 30/255, green: 27/255, blue: 47/255, alpha: 1)
        User.instance.getChats(success: {
            // success
            self.chats_list = User.instance.chat_ids
            self.tableView.reloadData()
            print("inside....")
        }) {
            // failure
            self.chats_list = []
            self.tableView.reloadData()
            print("inside....")
        }
        print("after....")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.chats_list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message_cell", for: indexPath) as! MessageTableViewCell

        cell.backgroundColor = UIColor(red: 30/255, green: 27/255, blue: 47/255, alpha: 1)
        let chat_id = self.chats_list[indexPath.row]
        
        
        // get chat members for the chat and save is into cell labels
        User.instance.getMembersFromChat(chat_id: chat_id, success: { (member1, member2) in
            // success
            print("member1 = ", member1)
            print("member2 = ", member2)
            print("user name = ", User.instance.firstName)
            if User.instance.firstName == member1 {
                cell.name_label.text = member2
            }
            else{
                cell.name_label.text = member1

            }
        }) {
            
            // failure
        }
        
        return cell
    }
    

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "messages_view_controller")
//        self.present(viewController, animated: true, completion: nil)
//    }

}
