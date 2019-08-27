//
//  TimeSlotCell.swift
//  Rush
//
//  Created by ideveloper on 20/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {

    @IBOutlet weak var textField: AkiraTextField!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var textDidChanged: ((_ text: String) -> Void)?
    var textDidEndEditing: ((_ text: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension UserInfoCell {
    
    func setup(placeholder: String, title: String) {
        textField.placeholderColor = UIColor.textFiledPlaceHolder
        textField.placeholderLabel.textColor = (isFirstResponder || textField.text!.isNotEmpty) ? UIColor.bgBlack : UIColor.placeholderColor
        textField.text = title
        textField.placeholder = placeholder
    }
    
    func setup(iconImage: UIImage) {
        iconImageView.image = iconImage
    }
    
}
