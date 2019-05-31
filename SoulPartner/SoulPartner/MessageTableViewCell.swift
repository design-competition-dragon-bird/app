//
//  MessageTableViewCell.swift
//  SoulPartner
//
//  Created by Ravi Patel on 5/31/19.
//  Copyright © 2019 Saikiran Komatineni. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var image_icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
