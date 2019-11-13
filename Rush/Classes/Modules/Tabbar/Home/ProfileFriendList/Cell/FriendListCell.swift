//
//  FriendListCell.swift
//  Rush
//
//  Created by ideveloper on 06/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class FriendListCell: UITableViewCell {

    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension FriendListCell {
    func setup(name: String) {
        friendNameLabel.text = name
    }
    
    func setup(url: URL?) {
        friendImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder-profile-32px"))
    }
}
