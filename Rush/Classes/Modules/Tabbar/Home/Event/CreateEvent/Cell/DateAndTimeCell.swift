//
//  DateAndTimeCell.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class DateAndTimeCell: UITableViewCell {
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    
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

extension DateAndTimeCell {
    func setup(dateButtonText: String) {
        dateButton.setTitle(dateButtonText, for: .normal)
    }
    
    func setup(timeButtonText: String) {
        timeButton.setTitle(timeButtonText, for: .normal)
    }
    
    @IBAction func dateButtonAction() {
        dateButtonClickEvent?()
    }
    
    @IBAction func timeButtonAction() {
        timeButtonClickEvent?()
    }
    
}
