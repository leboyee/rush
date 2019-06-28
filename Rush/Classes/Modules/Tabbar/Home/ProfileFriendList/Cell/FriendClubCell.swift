//
//  FriendClubCell.swift
//  Rush
//
//  Created by ideveloper on 06/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class FriendClubCell: UITableViewCell {
    
    @IBOutlet weak var thirdUserImageView: UIImageView!
    @IBOutlet weak var secondUserImageView: UIImageView!
    @IBOutlet weak var firstUserImageView: UIImageView!
    @IBOutlet weak var userCountLabel: UILabel!
    @IBOutlet weak var titleLabel: CustomBlackLabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var topConstraintOfContentView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        firstUserImageView.layer.borderColor = UIColor.white.cgColor
        secondUserImageView.layer.borderColor = UIColor.white.cgColor
        thirdUserImageView.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Other functions
extension FriendClubCell {
    func setup(title: String) {
        titleLabel.text = title
    }
    
    func setup(detail: String) {
       detailLabel.text = detail
    }
    
    func setup(topConstraint: CGFloat) {
        topConstraintOfContentView.constant = topConstraint
    }
}
