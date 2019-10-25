//
//  ClubNameCell.swift
//  Rush
//
//  Created by ideveloper on 29/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ClubNameCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    var readMoreClickEvent: (() -> Void)?
    @IBOutlet weak var heightConstraintOfReadmoreButton: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintOfReadmoreButton: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraintOfName: NSLayoutConstraint!
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
extension ClubNameCell {
    func setup(title: String) {
        titleLabel.text = title
    }
    func setup(topHeight: CGFloat) {
        topConstraintOfName.constant = topHeight
    }
    
    func setupReadMoreButton() {
        
        let line = titleLabel.calculateMaxLines()
        if line < 3 {
            setup(isHideReadmoreButton: true)
        } else {
            setup(isHideReadmoreButton: false)
        }
    }
    
    func setup(detail: String, numberOfLines: Int) {
        detailLabel.text = detail
        detailLabel.numberOfLines = numberOfLines
        
        let line = detailLabel.calculateMaxLines()
        if line < 3 {
            setup(isHideReadmoreButton: true)
        } else {
            setup(isHideReadmoreButton: false)
        }
        
    }
    
    func setup(isHideReadmoreButton: Bool) {
        if isHideReadmoreButton {
            heightConstraintOfReadmoreButton.constant = 0
            bottomConstraintOfReadmoreButton.constant = 8
        } else {
            heightConstraintOfReadmoreButton.constant = 28
            bottomConstraintOfReadmoreButton.constant = 24
        }
    }
    
    func setup(readmoreSelected: Bool) {
        if readmoreSelected {
            readMoreButton.setTitle(Text.readLess, for: .normal)
        } else {
            readMoreButton.setTitle(Text.readMore, for: .normal)
        }
    }
    
    func setup(detailTextColor: UIColor) {
        detailLabel.textColor = detailTextColor
    }
    
    @IBAction func readMoreButtonAction() {
        readMoreClickEvent?()
    }
}
