//
//  PostCommentCell.swift
//  Rush
//
//  Created by ideveloper on 25/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class PostCommentCell: UITableViewCell {
    
    @IBOutlet weak var leadingConstrainttOfImageView: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintOfImageView: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintOfImageView: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    

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
extension PostCommentCell {
    func setup(isReplayCell: Bool) {
        if isReplayCell {
            widthConstraintOfImageView.constant = 24
            heightConstraintOfImageView.constant = 24
            leadingConstrainttOfImageView.constant = 72
            imgView.layer.cornerRadius = 12
        } else {
            widthConstraintOfImageView.constant = 40
            heightConstraintOfImageView.constant = 40
            leadingConstrainttOfImageView.constant = 24
            imgView.layer.cornerRadius = 20
        }
    }
    
    @IBAction func replayButtonAction() {
        
    }
}
