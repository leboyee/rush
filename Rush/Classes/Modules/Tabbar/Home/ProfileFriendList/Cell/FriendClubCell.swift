//
//  FriendClubCell.swift
//  Rush
//
//  Created by ideveloper on 06/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class FriendClubCell: UITableViewCell {
    
    @IBOutlet weak var thirdUserImageView: UIImageView!
    @IBOutlet weak var secondUserImageView: UIImageView!
    @IBOutlet weak var firstUserImageView: UIImageView!
    @IBOutlet weak var userCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        firstUserImageView.layer.borderColor = UIColor.white.cgColor
        secondUserImageView.layer.borderColor = UIColor.white.cgColor
        thirdUserImageView.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
