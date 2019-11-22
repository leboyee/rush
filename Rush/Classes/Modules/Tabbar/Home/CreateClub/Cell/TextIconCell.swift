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
    @IBOutlet weak var chatSwitch: UISwitch!
    @IBOutlet weak var topConstraintOfLabel: NSLayoutConstraint!
    
    var textDidChanged: ((_ text: String) -> Void)?
    var clearButtonClickEvent:(() -> Void)?
    var textDidEndEditing: ((_ text: String) -> Void)?
    var switchValueChanged: ((_ isOn: Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if isDarkModeOn {
            textField.textColor = .white
        }
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
    
    func setup(placeholder: String, title: String) {
        textField.text = title
        textField.placeholder = placeholder
    }
    
    func setup(placeholder: String) {
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGrayColor, NSAttributedString.Key.font: UIFont.regular(sz: 17.0)]
        let attstr = NSMutableAttributedString(string: placeholder, attributes: attributes)
        textField.attributedPlaceholder = attstr
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
        textField.isUserInteractionEnabled = isUserInterfaceEnable
    }
    
    func setup(keyboardReturnKeyType: UIReturnKeyType) {
        textField.returnKeyType = keyboardReturnKeyType
    }
    
    func setup(isShowSwitch: Bool) {
        chatSwitch.isHidden = !isShowSwitch
        clearButton.isHidden = isShowSwitch
    }
    
    func resetAllField() {
        setup(iconImage: "")
        setup(isUserInterfaceEnable: false)
        setup(isShowSwitch: false)
        setup(isHideCleareButton: true)
    }
    
    func setup(topLabelConstraint: CGFloat) {
        topConstraintOfLabel.constant = topLabelConstraint
    }
    
    func setup(isSetDropDown: Bool) {
        if isSetDropDown {
            clearButton.setImage(#imageLiteral(resourceName: "downArrow"), for: .normal)
        } else {
            clearButton.setImage(#imageLiteral(resourceName: "delete-white"), for: .normal)
        }
    }
    
    @IBAction func clearButtonAction() {
        clearButtonClickEvent?()
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        
        if let swich = sender as? UISwitch {
            switchValueChanged?(swich.isOn)
        }
    }
    
}

extension TextIconCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), !text.isEmpty {
            textDidEndEditing?(text)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textDidChanged?(textField.text ?? "")
    }
}
