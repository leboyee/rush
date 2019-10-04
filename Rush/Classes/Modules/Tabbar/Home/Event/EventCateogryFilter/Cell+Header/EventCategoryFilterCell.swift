//
//  EventCategoryFilterCell.swift
//  Rush
//
//  Created by ideveloper on 15/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EventCategoryFilterCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension EventCategoryFilterCell {
    
    func setup(name: String) {
        nameLabel.text = name
    }
    
    func setup(checkMarkHidden: Bool) {
        checkMarkImageView.isHidden = checkMarkHidden
    }
}
