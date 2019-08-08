//
//  SettingsInfoCell.swift
//  Rush
//
//  Created by kamal on 08/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class SettingsInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: CustomBlackLabel!
    @IBOutlet weak var detailLabel: CustomBlackLabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
