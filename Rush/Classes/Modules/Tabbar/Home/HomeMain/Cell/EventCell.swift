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
    
    func setup(user: [String]) {
        
        userCountLabel.isHidden = true
        firstUserImageView.isHidden = false
        secondUserImageView.isHidden = false
        thirdUserImageView.isHidden = false
        
        if user.count == 0 {
            userView.isHidden = true
        } else if user.count == 1 {
            secondUserImageView.isHidden = true
            thirdUserImageView.isHidden = true
        } else if user.count == 2 {
            thirdUserImageView.isHidden = true
        }
        
        if user.count > 3 {
            userCountLabel.isHidden = false
            userCountLabel.text = "\(user.count)+"
        }
    }
}
