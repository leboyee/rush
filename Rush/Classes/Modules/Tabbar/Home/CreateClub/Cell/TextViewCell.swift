//
//  TextViewCell.swift
//  Rush
//
//  Created by ideveloper on 20/05/19.
//  Copyright © 2019 Messapps. All rights reserved.

import UIKit

class TextViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var topPlaceHolderConstraint: NSLayoutConstraint!
    @IBOutlet weak var topTextViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var clearButton: UIButton!
    
    var textDidChanged: ((_ text : String) -> Void)?
    var clearButtonClickEvent:(() -> Void)?
    var textDidEndEditing: ((_ text : String) -> Void)?
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

extension TextViewCell {
    
    func resetAllField() {
        setup(isHideCleareButton: true)
        setup(iconImage: "")
        setup(isUserInterfaceEnable: false)
        setup(isHideCleareButton: true)
    }
    
    func setup(isEmpty: Bool) {
        if isEmpty {
            placeHolderLabel.font = UIFont.Regular(sz: 17.0)
            topPlaceHolderConstraint.constant = 17
            topTextViewConstraint.constant = 15
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
            topPlaceHolderConstraint.constant = 8
            topTextViewConstraint.constant = 25
        }
        layoutIfNeeded()
    }
    
    func setup(placehoder: String) {
        placeHolderLabel.text = placehoder
    }
    
    func setup(placeholder: String, text: String) {
        textView.text = text
        setup(isEmpty: text.isEmpty)
    }
    
    func setup(iconImage: String) {
        imgView.image = UIImage(named: iconImage)
    }
    
    func setup(isHideClearButton: Bool) {
        clearButton.isHidden = isHideClearButton
    }
    
    func setup(isUserInterfaceEnable: Bool) {
        textView.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    func setup(isHideCleareButton: Bool) {
        clearButton.isHidden = isHideCleareButton
    }
    
    func setup(placeholder: String) {
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGrayColor, NSAttributedString.Key.font: UIFont.Regular(sz: 17.0)]
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

extension TextViewCell: UITextViewDelegate {
    
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
