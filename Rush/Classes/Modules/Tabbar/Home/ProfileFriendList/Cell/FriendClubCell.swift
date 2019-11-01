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
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    
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
    
    func setup(imageUrl: URL?) {
        mainImageView.sd_setImage(with: imageUrl, completed: nil)
    }
    
    // use this for club
    func setup(clubImageUrl: URL?) {
        mainImageView.sd_setImage(with: clubImageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder-club48px"))
    }
    
    // use this for classes
    func setup(classesImageUrl: URL?) {
        mainImageView.sd_setImage(with: classesImageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder-classChat-#1"))
    }
    
    func setup(invitee: [Invitee]?) {
        
        userCountLabel.isHidden = true
        firstUserImageView.isHidden = false
        secondUserImageView.isHidden = false
        thirdUserImageView.isHidden = false
        
        if invitee?.count == 0 {
            userView.isHidden = true
        } else if invitee?.count == 1 {
            firstUserImageView.isHidden = true
            secondUserImageView.isHidden = true
            let clubInvitee = invitee?[0]
            thirdUserImageView.sd_setImage(with: clubInvitee?.user?.photo?.url(), completed: nil)
        } else if invitee?.count == 2 {
            firstUserImageView.isHidden = true
            var clubInvitee = invitee?[0]
            thirdUserImageView.sd_setImage(with: clubInvitee?.user?.photo?.url(), completed: nil)
            clubInvitee = invitee?[1]
            secondUserImageView.sd_setImage(with: clubInvitee?.user?.photo?.url(), completed: nil)
        } else if invitee?.count ?? 0 > 2 {
            var clubInvitee = invitee?[0]
            thirdUserImageView.sd_setImage(with: clubInvitee?.user?.photo?.url(), completed: nil)
            clubInvitee = invitee?[1]
            secondUserImageView.sd_setImage(with: clubInvitee?.user?.photo?.url(), completed: nil)
            clubInvitee = invitee?[2]
            thirdUserImageView.sd_setImage(with: clubInvitee?.user?.photo?.url(), completed: nil)
            let count = invitee?.count ?? 0
            if count > 3 {
                userCountLabel.isHidden = false
                userCountLabel.text = "\(count)+"
            }
        }
    }
}
