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
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: CustomBlackLabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var leadingSeparatorConstraint: NSLayoutConstraint!

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


//MARK: - Data
extension CalendarEventCell {
    
    func set(eventName: String) {
        titleLabel.text = eventName
    }
    
    func set(type: String) {
        typeLabel.text = type
    }
    
    func set(path: String?) {
        if let url = path {
            eventImageView.sd_setImage(with: URL(string: url), placeholderImage: nil)
        } else {
            eventImageView.image = nil
        }
    }
    
    
    func set(date: Date?) {
        if let date = date {
            monthLabel.text = date.toString(format: "MMM").uppercased()
            dateLabel.text = date.toString(format: "dd")
        } else {
            monthLabel.text = ""
            dateLabel.text = ""
        }
        
    }
    
    func set(start: Date?, end: Date?) {
        
        if let startDate = start {
            var text = startDate.toString(format: "hh:mm a")
            if let endDate = end {
               text = text + "\n" +  endDate.toString(format: "hh:mm a")
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
    
}
