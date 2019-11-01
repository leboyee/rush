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
     var joinSelected: (() -> Void)?
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
        
    @IBAction func joinButtonAction() {
        joinSelected?()
    }
}

extension EventCell {
    
    func setup(type: EventCategoryType) {
        userView.isHidden = true
        if type == .upcoming {
            //self.joinButton.isUserInteractionEnabled = true
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
    
    // use this for event small icon
    func setup(eventImageUrl: URL?) {
        eventImageView.sd_setImage(with: eventImageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder-event48px"))
    }
    
    // use this for club small icon
    func setup(clubImageUrl: URL?) {
        eventImageView.sd_setImage(with: clubImageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder-club48px"))
    }
    
    // use this for classes small icon
    func setup(classesSmallImageUrl: URL?) {
        eventImageView.sd_setImage(with: classesSmallImageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder-classChat-#1"))
    }
    
    func setup(classImageUrl: URL?) {
        classImageView.sd_setImage(with: classImageUrl, placeholderImage: #imageLiteral(resourceName: "placeholder-classCard"))
    }
    
    func setup(date: Date?) {
        guard let date = date else {
            dateLabel.isHidden = true
            return
        }
        
        dateLabel.isHidden = false
        dateLabel.text = date.toString(format: "MMM").uppercased()
        dateNumericLabel.text = date.toString(format: "dd")
        //        dayLabel.text = date.toString(format: "EEEE")
        
    }
    
    func setup(start: Date?, end: Date?) {
        
        guard let startDate = start else {
            timeLabel.text = ""
            return
        }
        
        var text = startDate.toString(format: "hh:mma")
        if let endDate = end {
            text +=  "-" +  endDate.toString(format: "hh:mma")
        }
        timeLabel.text = text
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
    
    func setup(isHideInvitee: Bool) {
        joinButton.isHidden = !isHideInvitee
        userView.isHidden = isHideInvitee
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
                thirdUserImageView.sd_setImage(with: clubInvitee?.user?.photo?.url(), placeholderImage: #imageLiteral(resourceName: "placeholder-profile-tabBar"), context: nil)
           
        } else if invitee?.count == 2 {
            firstUserImageView.isHidden = true
            var clubInvitee = invitee?[0]
            thirdUserImageView.sd_setImage(with: clubInvitee?.user?.photo?.url(), placeholderImage: #imageLiteral(resourceName: "placeholder-profile-tabBar"), context: nil)
            clubInvitee = invitee?[1]
            secondUserImageView.sd_setImage(with: clubInvitee?.user?.photo?.url(), placeholderImage: #imageLiteral(resourceName: "placeholder-profile-tabBar"), context: nil)
        } else if invitee?.count ?? 0 > 2 {
            var clubInvitee = invitee?[0]
            thirdUserImageView.sd_setImage(with: clubInvitee?.user?.photo?.url(), placeholderImage: #imageLiteral(resourceName: "placeholder-profile-tabBar"), context: nil)
            clubInvitee = invitee?[1]
            secondUserImageView.sd_setImage(with: clubInvitee?.user?.photo?.url(), placeholderImage: #imageLiteral(resourceName: "placeholder-profile-tabBar"), context: nil)
            clubInvitee = invitee?[2]
            thirdUserImageView.sd_setImage(with: clubInvitee?.user?.photo?.url(), placeholderImage: #imageLiteral(resourceName: "placeholder-profile-tabBar"), context: nil)
            let count = (invitee?.count ?? 0) - 3
            if count > 0 {
                userCountLabel.isHidden = false
                userCountLabel.text = "\(count)+"
            }
        }
    }
    
    func setup(className: String) {
        classNameLabel.text = className
    }
    
    func setup(classCount: String) {
        classCountLabel.text = classCount
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
