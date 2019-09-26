//
//  EventCell.swift
//  Rush
//
//  Created by ideveloper on 13/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var privacyImageView: UIImageView!
    @IBOutlet weak var widthConstraintOfDateView: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateNumericLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var leadingConstraintOfDateView: NSLayoutConstraint!
    
    @IBOutlet weak var userView: UIView!
    
    @IBOutlet weak var classImageView: UIImageView!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var classCountLabel: UILabel!
    
    @IBOutlet weak var thirdUserImageView: UIImageView!
    @IBOutlet weak var secondUserImageView: UIImageView!
    @IBOutlet weak var firstUserImageView: UIImageView!
    @IBOutlet weak var userCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    func setupUI() {
        firstUserImageView.layer.borderColor = UIColor.white.cgColor
        secondUserImageView.layer.borderColor = UIColor.white.cgColor
        thirdUserImageView.layer.borderColor = UIColor.white.cgColor
    }
}

extension EventCell {
    
    func setup(type: EventCategoryType) {
        userView.isHidden = true
        if type == .upcoming {
            
        } else if type == .clubs || type == .clubsJoined {
            setup(isHideDateView: true)
            setup(isHidePrivacyView: true)
            setup(isShowCategotyView: false)
            if type == .clubsJoined {
                joinButton.isHidden = true
                userView.isHidden = false
            }
        } else if type == .classes {
            setup(isShowCategotyView: true)
        }
    }
    
    func setup(eventName: String) {
        eventNameLabel.text = eventName
    }
    
    func setup(eventDetail: String) {
        timeLabel.text = eventDetail
    }
    
    func setup(eventImageUrl: URL?) {
        eventImageView.sd_setImage(with: eventImageUrl, completed: nil)
    }
    
    func setup(isHideDateView: Bool) {
        if isHideDateView {
            widthConstraintOfDateView.constant = 0
            leadingConstraintOfDateView.constant = 0
        } else {
            widthConstraintOfDateView.constant = 48
            leadingConstraintOfDateView.constant = 16
        }
    }
    
    func setup(isShowCategotyView: Bool) {
        if isShowCategotyView {
            eventView.isHidden = true
            categoryView.isHidden = false
        } else {
            eventView.isHidden = false
            categoryView.isHidden = true
        }
    }
    
    func setup(isHidePrivacyView: Bool) {
        if isHidePrivacyView {
            privacyImageView.isHidden = true
        } else {
            privacyImageView.isHidden = false
        }
    }
    
    func setup(invitee: [Invitees]?) {
        
        userCountLabel.isHidden = true
        firstUserImageView.isHidden = false
        secondUserImageView.isHidden = false
        thirdUserImageView.isHidden = false
        
        if invitee?.count ?? 0 == 0 {
            userView.isHidden = true
        } else if invitee?.count ?? 0 == 1 || invitee?.count ?? 0 > 2 {
            firstUserImageView.isHidden = true
            secondUserImageView.isHidden = true
        } else if invitee?.count ?? 0 == 2 || invitee?.count ?? 0 > 2 {
            firstUserImageView.isHidden = true
        }
        
        if invitee?.count ?? 0 > 3 {
            userCountLabel.isHidden = false
            let count = invitee?.count ?? 0
            userCountLabel.text = "\(count - 3)+"
        }
    }
    
    func setup(eventType: EventType) {
        if eventType == .publik {
            privacyImageView.image = #imageLiteral(resourceName: "privacy-public")
        } else if eventType == .closed {
           privacyImageView.image = #imageLiteral(resourceName: "privacy-lock")
        } else if eventType == .inviteOnly {
            privacyImageView.image = #imageLiteral(resourceName: "invite-blue")
        }
    }
}
