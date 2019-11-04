//
//  OrganizerCell.swift
//  Rush
//
//  Created by kamal on 10/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class OrganizerCell: UITableViewCell {

    @IBOutlet weak var nameLabel: CustomBlackLabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension OrganizerCell {
    
    func set(name: String) {
        nameLabel.text = name
    }
    
    func set(detail: String) {
        detailLabel.text = detail
    }
    
    func set(url: URL?) {
        profileImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder-profile-48px"))
    }
}
