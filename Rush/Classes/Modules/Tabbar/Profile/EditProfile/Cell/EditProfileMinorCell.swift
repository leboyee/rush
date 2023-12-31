//
//  EditProfileMinorCell.swift
//  Rush
//
//  Created by Suresh Jagnani on 04/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EditProfileMinorCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var topPlaceHolderConstraint: NSLayoutConstraint!
    @IBOutlet weak var topTextViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraintOfBgView: NSLayoutConstraint!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var bottomLine: UIView!

    var textDidChanged: ((_ text: String) -> Void)?
    var clearButtonClickEvent:(() -> Void)?
    var textDidEndEditing: ((_ text: String) -> Void)?
    var updateTableView:((_ textView: UITextView) -> Void)?
    
    var maxLength = 300
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets.zero
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

extension EditProfileMinorCell {
    
    func resetAllField() {
        topConstraintOfBgView.constant = 0
        setup(isHideCleareButton: true)
        setup(isUserInterfaceEnable: false)
        setup(isHideCleareButton: true)
    }
    
    func setup(isEmpty: Bool) {
        if isEmpty {
            placeHolderLabel.font = UIFont.regular(sz: 17.0)
            topPlaceHolderConstraint.constant = 17
            topTextViewConstraint.constant = 15
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
            topPlaceHolderConstraint.constant = 8
            topTextViewConstraint.constant = 20
        }
        layoutIfNeeded()
    }
    
    func setup(placehoder: String) {
        placeHolderLabel.text = placehoder
    }
    
    func setup(placeholder: String, text: String) {
        textView.text = text
        placeHolderLabel.text = placeholder
        setup(isEmpty: text.isEmpty)
    }
    
    func setup(isHideClearButton: Bool) {
        clearButton.isHidden = isHideClearButton
    }
    
    func setup(isUserInterfaceEnable: Bool) {
        textView.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    func setup(isEnabled: Bool) {
        textView.isUserInteractionEnabled = isEnabled
    }
    
    func setup(isHideCleareButton: Bool) {
        clearButton.isHidden = isHideCleareButton
    }
    
    func setup(isHiddenBottomLine: Bool) {
        bottomLine.isHidden = isHiddenBottomLine
    }
    
    func setup(placeholder: String) {
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGrayColor, NSAttributedString.Key.font: UIFont.regular(sz: 17.0)]
        let attstr = NSMutableAttributedString(string: placeholder, attributes: attributes)
        placeHolderLabel.attributedText = attstr
    }
    
    func setup(keyboardReturnKeyType: UIReturnKeyType) {
        textView.returnKeyType = keyboardReturnKeyType
    }
    
    @IBAction func clearButtonAction() {
        clearButtonClickEvent?()
    }
}

extension EditProfileMinorCell: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        setup(isEmpty: false)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let text = textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if text.count == 0 {
            setup(isEmpty: true)
            textView.text = text
        } else {
            setup(isEmpty: false)
        }
        textDidEndEditing?(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" && textView.returnKeyType == .done {
            textView.resignFirstResponder()
            return false
        }
        
        let currentString: NSString = textView.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: text) as NSString
        return newString.length <= maxLength
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textDidChanged?(textView.text)
        updateTableView?(textView)
    }
}
