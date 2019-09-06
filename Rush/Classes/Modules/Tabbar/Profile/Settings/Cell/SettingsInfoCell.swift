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
extension SettingsInfoCell {
    
    @IBAction func rightButtonAction() {
        rightEvent?()
    }
    
}

// MARK: - Data Functions
extension SettingsInfoCell {
    
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
    
}
