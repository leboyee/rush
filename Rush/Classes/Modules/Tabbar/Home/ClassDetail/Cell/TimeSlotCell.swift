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
    
    var textDidChanged: ((_ text : String) -> Void)?
    var clearButtonClickEvent:(() -> Void)?
    var textDidEndEditing: ((_ text : String) -> Void)?
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
    
    func setup(titleColor: UIColor) {
        textField.textColor = titleColor
    }
    
    
    func setup(placeholder: String,title: String) {
        textField.text = title
        textField.placeholder = placeholder
    }
    
    func setup(isUserInterfaceEnable: Bool) {
        textField.isUserInteractionEnabled = isUserInterfaceEnable
    }
    
    func setup(isHideDropDown: Bool) {
        upArrowImageView.isHidden = isHideDropDown
        iconImageView.isHidden = isHideDropDown
    }
    
    @IBAction func clearButtonAction() {
        clearButtonClickEvent?()
    }
    
}
