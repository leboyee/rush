//
//  DateAndTimeCell.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class AddEventCalendarCell: UITableViewCell {
    
    @IBOutlet weak var calendarView: CalendarView!

    override func awakeFromNib() {
        super.awakeFromNib()
        calendarView.dateColor = UIColor.bgBlack
        calendarView.dateSelectedColor = UIColor.white
        calendarView.selectedDate(date: Date())
        calendarView.reloadMonth()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension AddEventCalendarCell {
    
}
