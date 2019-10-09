//
//  EditProfileInfoCell.swift
//  Rush
//
//  Created by Suresh Jagnani on 04/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EditProfileInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: CustomBlackLabel!
    @IBOutlet weak var detailLabel: CustomBlackLabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint!


    var rightEvent: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Actions
extension EditProfileInfoCell {
    
    @IBAction func rightButtonAction() {
        rightEvent?()
    }
    
}

// MARK: - Data Functions
extension EditProfileInfoCell {
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(detail: String) {
        detailLabel.text = detail
    }
    
    func set(isHideRightButton: Bool) {
        rightButton.isHidden = isHideRightButton
    }
    
    func set(isHideArrow: Bool) {
        arrowImageView.isHidden = isHideArrow
    }
    
    func set(arrowImage: UIImage) {
          arrowImageView.image = arrowImage
      }
    
    func set(titleTextColor: UIColor) {
        titleLabel.textColor = titleTextColor
    }
    
    func set(detailsTextColor: UIColor) {
        detailLabel.textColor = detailsTextColor
    }
    
    func set(isDetails: Bool) {
        if isDetails == true {
            titleLabel.font = UIFont.semibold(sz: 13)
            titleLabelHeightConstraint.constant = 16
        } else {
            titleLabel.font = UIFont.regular(sz: 17)
            titleLabelHeightConstraint.constant = 42
        }
    }
}
