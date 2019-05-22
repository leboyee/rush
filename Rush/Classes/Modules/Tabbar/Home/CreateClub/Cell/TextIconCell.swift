//
//  TextIconCell.swift
//  Rush
//
//  Created by ideveloper on 20/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class TextIconCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    var clearButtonClickEvent:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TextIconCell {
    
    func setup(titleColor: UIColor) {
        textField.textColor = titleColor
    }
    
    func setup(isHideCleareButton: Bool) {
        clearButton.isHidden = isHideCleareButton
    }
    
    func setup(title: String) {
        textField.text = title
    }
    
    func setup(iconImage: String) {
        if iconImage.isEmpty {
            iconImageView.isHidden = true
        } else {
            iconImageView.image = UIImage(named: iconImage)
            iconImageView.isHidden = false
        }
    }
    
    func setup(isUserInterfaceEnable: Bool) {
        textField.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    @IBAction func clearButtonAction() {
        clearButtonClickEvent?()
    }
    
}

extension TextIconCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        if text == "Name club" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
