//
//  EventCategoryFilterCell.swift
//  Rush
//
//  Created by ideveloper on 15/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EventTypeModelCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var eventDetailLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var eventTypeImageView: UIImageView!
    var evenType: EventType = .publik

    override func awakeFromNib() {
        super.awakeFromNib()
        eventDetailLabel.numberOfLines = 0
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension EventTypeModelCell {
    func set(type: EventType) {
        if type == .closed {
            eventTypeImageView.image = #imageLiteral(resourceName: "ic_closed.pdf")
            nameLabel.text = "Closed"
            eventDetailLabel.text = "Anyone within your college or university can see the flyer. Non-invited users must submit request to see event information."
        } else if type == .publik {
            eventTypeImageView.image = #imageLiteral(resourceName: "ic_public.pdf")
            nameLabel.text = "Public"
            eventDetailLabel.text = "Anyone within your college or university can see the flyer, the attendees, and the event information."
        } else {
            eventTypeImageView.image = #imageLiteral(resourceName: "ic_inviteonly.pdf")
            nameLabel.text = "Invite only"
            eventDetailLabel.text = "Only members can see the flyer, who’s is invited, and the event information."
        }
    }
    
    func setup(checkMarkHidden: Bool) {
        checkMarkImageView.isHidden = checkMarkHidden
    }
    
    func setup(detail: String) {
        eventDetailLabel.text = detail
    }
    
    func setup(isSelected: Bool) {
        cellBackgroundView.backgroundColor = isSelected == true ? .lightGray93 : .white
    }
    
}
