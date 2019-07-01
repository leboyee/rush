//
//  EventByDateCell.swift
//  Rush
//
//  Created by ideveloper on 15/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EventByDateCell: UITableViewCell {

    @IBOutlet weak var leadingConstraintOfDateView: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintOfDateView: NSLayoutConstraint!
    @IBOutlet weak var topConstraintOfImageView: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: CustomBlackLabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
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
extension EventByDateCell {
    
    func setup(title: String) {
        titleLabel.text = title
    }
    
    func setup(detail: String) {
        detailLabel.text = detail
    }
    
    func setup(isRemoveDateView: Bool) {
        if isRemoveDateView {
            leadingConstraintOfDateView.constant = 8
            widthConstraintOfDateView.constant = 0
            topConstraintOfImageView.constant = 0
        } else {
            leadingConstraintOfDateView.constant = 16
            widthConstraintOfDateView.constant = 48
            topConstraintOfImageView.constant = 20
        }
    }
    
    func setup(cornerRadius: CGFloat) {
        imgView.layer.cornerRadius = cornerRadius
    }
}
