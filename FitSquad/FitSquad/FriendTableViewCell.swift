//
//  FriendTableViewCell.swift
//  FitSquad
//
//  Created by Jaimie Zhu on 3/8/17.
//  Copyright © 2017 dogdogdog. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
