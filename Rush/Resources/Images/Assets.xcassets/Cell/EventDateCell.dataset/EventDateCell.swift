//
//  DateAndTimeCell.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EventDateCell: UITableViewCell {
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var iconImageView: UIView!

    var dateButtonClickEvent:(() -> Void)?
    var timeButtonClickEvent:(() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension EventDateCell {
    func setup(dateButtonText: String) {
        dateButton.setTitle(dateButtonText, for: .normal)
    }
        
    @IBAction func dateButtonAction() {
        dateButtonClickEvent?()
    }
    
    @IBAction func timeButtonAction() {
        timeButtonClickEvent?()
    }
    
}
