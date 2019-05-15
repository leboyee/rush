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
    
    
    @IBOutlet weak var classImageView: UIImageView!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var classCountLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension EventCell {
    
    func setup(type: EventType) {
        
        if type == .upcoming {
            
        } else if type == .clubs {
            setup(isHideDateView: true)
            setup(isHidePrivacyView: true)
            setup(isShowCategotyView: false)
        } else if type == .clubsJoined {
            setup(isShowCategotyView: false)
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
}
