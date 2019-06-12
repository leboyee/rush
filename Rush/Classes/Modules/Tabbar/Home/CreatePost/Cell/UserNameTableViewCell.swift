//
//  UserNameTableViewCell.swift
//  Rush
//
//  Created by ideveloper2 on 12/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class UserNameTableViewCell: UITableViewCell {

    @IBOutlet weak var postUserDescripation: UILabel!
    @IBOutlet weak var postUserName: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = postImageView.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
