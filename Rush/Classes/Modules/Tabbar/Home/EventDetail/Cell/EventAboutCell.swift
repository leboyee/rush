//
//  EventAboutCell.swift
//  Rush
//
//  Created by kamal on 04/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EventAboutCell: UITableViewCell {

    @IBOutlet var eventTypeView: UIView!
    @IBOutlet var eventTypeIconImageView: UIImageView!
    @IBOutlet var eventTypeLabel: CustomBlackLabel!
    @IBOutlet var eventTitleLabel: CustomBlackLabel!
    @IBOutlet var eventDetailLabel: CustomBlackLabel!
    @IBOutlet var readMoreView: UIView!
    @IBOutlet var readMoreButtonViewHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension EventAboutCell {
    
    func set(isHideType: Bool) {
        eventTypeView.isHidden = isHideType
    }
    
    func set(isHideReadMore: Bool) {
        readMoreView.isHidden = isHideReadMore
        readMoreButtonViewHeight.constant = isHideReadMore ? 0 : 22
    }
    
    func set(title: String) {
        eventTitleLabel.text = title
    }
    
    func set(detail: String) {
        eventDetailLabel.text = detail
    }
    
    func set(type: EventType) {
        if type == .closed {
            eventTypeIconImageView.image = #imageLiteral(resourceName: "ic_closed.pdf")
            eventTypeLabel.text = "Closed Event"
        } else if type == .publik {
            eventTypeIconImageView.image = #imageLiteral(resourceName: "ic_public.pdf")
            eventTypeLabel.text = "Public Event"
        } else {
            eventTypeIconImageView.image = #imageLiteral(resourceName: "ic_inviteonly.pdf")
            eventTypeLabel.text = "Invite Only Event"
        }
    }
}
