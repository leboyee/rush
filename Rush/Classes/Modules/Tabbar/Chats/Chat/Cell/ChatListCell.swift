//
//  ChatListCell.swift
//  Rush
//
//  Created by ideveloper on 15/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {

    @IBOutlet weak var topConstraintOfImageView: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintOfImageView: NSLayoutConstraint!
    @IBOutlet weak var bottomContraintOfDateLabel: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: CustomBlackLabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Other functions
extension ChatListCell {
    
    func setup(title: String) {
        titleLabel.text = title
    }
    
    func setup(detail: String) {
        detailLabel.text = detail
    }
    
    func setup(bottomConstraintOfImage: CGFloat) {
        bottomConstraintOfImageView.constant = bottomConstraintOfImage
    }
    
    func setup(bottomConstraintOfDate: CGFloat) {
        bottomContraintOfDateLabel.constant = bottomConstraintOfDate
    }
    
    func setup(cornerRadius: CGFloat) {
        imgView.layer.cornerRadius = cornerRadius
    }
    
    func setup(isHideSeparator: Bool) {
        separatorView.isHidden = isHideSeparator
    }
}
