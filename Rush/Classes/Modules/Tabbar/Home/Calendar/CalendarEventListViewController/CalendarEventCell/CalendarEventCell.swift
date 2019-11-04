//
//  CalendarEventCell.swift
//  Rush
//
//  Created by kamal on 07/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import SDWebImage

class CalendarEventCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: CustomBlackLabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var leadingSeparatorConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeRedLineImageView: UIImageView!
    @IBOutlet weak var separatorBottom: UIView!

    let normal: CGFloat = 24.0
    let extra: CGFloat = 80.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - Data
extension CalendarEventCell {
    
    func set(eventName: String) {
        titleLabel.text = eventName
    }
    
    func set(type: String) {
        typeLabel.text = type
    }
    
    func set(url: URL?) {
        eventImageView.sd_setImage(with: url, placeholderImage: nil)
    }
    
    func set(start: Date?, end: Date?) {
        if let startDate = start {
            var text = startDate.toString(format: "hh:mm a")
            if let endDate = end {
               text += "\n" +  endDate.toString(format: "hh:mm a")
            }
            timeLabel.text = text
        } else {
            timeLabel.text = ""
        }
    }
    
    func set(isNormal: Bool) {
        leadingSeparatorConstraint.constant = isNormal ? normal : extra
        layoutIfNeeded()
    }
    
    func set(isHideBottom: Bool) {
        separatorBottom.isHidden = isHideBottom
    }
    
    func set(isHideRedTimeline: Bool) {
        timeRedLineImageView.isHidden = isHideRedTimeline
    }
    
}
