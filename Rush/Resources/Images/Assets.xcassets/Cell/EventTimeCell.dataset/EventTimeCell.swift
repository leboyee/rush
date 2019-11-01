//
//  EventTimeCell.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EventTimeCell: UITableViewCell {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var timeSelected:((_ date: Date) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
            datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension EventTimeCell {
        
    @objc func datePickerChanged(picker: UIDatePicker) {
        timeSelected?(picker.date)
    }
    
    func setMinimumTime(date: Date) {
        datePicker.minimumDate = date
    }
}
