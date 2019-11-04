//
//  CreatePostCell.swift
//  Rush
//
//  Created by kamal on 05/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CreatePostCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CreatePostCell {
    func set(url: URL?) {
        profileImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder-profile-48px"))
    }
}
