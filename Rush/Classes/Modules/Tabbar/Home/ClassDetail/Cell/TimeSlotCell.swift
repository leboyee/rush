//
//  TimeSlotCell.swift
//  Rush
//
//  Created by ideveloper on 20/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class TimeSlotCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var upArrowImageView: UIImageView!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var textDidChanged: ((_ text: String) -> Void)?
    var clearButtonClickEvent:(() -> Void)?
    var textDidEndEditing: ((_ text: String) -> Void)?
    var switchValueChanged: ((_ isOn: Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension TimeSlotCell {
    
    func setup(day: String) {
        dayLabel.text = day
    }
    
    func setup(start: String, end: String) {
     /*   guard let startDate = start else {
                   timeLabel.text = ""
                   return
               }
               
               var text = startDate.toString(format: "hh:mm a")
               if let endDate = end {
                   text +=  "-" +  endDate.toString(format: "hh:mm a")
               }*/
               timeLabel.text = start + "-" + end
        
    }
    
    func setup(isHideDropDown: Bool) {
        upArrowImageView.isHidden = isHideDropDown
        iconImageView.isHidden = isHideDropDown
    }
    
    @IBAction func clearButtonAction() {
        clearButtonClickEvent?()
    }
    
}
