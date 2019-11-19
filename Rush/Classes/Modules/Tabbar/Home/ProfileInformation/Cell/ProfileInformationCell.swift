//
//  ProfileTextFieldCell.swift
//  Rush
//
//  Created by ideveloper on 04/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ProfileInformationCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var heightConstraintOfPlaceholder: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintofDetailLabel: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Other function
extension ProfileInformationCell {
    func setup(text: String, placeholder: String) {
        titleLabel.text = placeholder
        detailLabel.text = text
        if placeholder.isEmpty {
            heightConstraintOfPlaceholder.constant = 0
            bottomConstraintofDetailLabel.constant = 16
        } else {
            heightConstraintOfPlaceholder.constant = 16
            bottomConstraintofDetailLabel.constant = 11
        }
    }
}
