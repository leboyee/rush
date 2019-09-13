//
//  RSVPCell.swift
//  Rush
//
//  Created by ideveloper on 20/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class RSVPCell: UITableViewCell {
    
    @IBOutlet weak var dataTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var clearButton: UIView!

    var textDidChanged: ((_ text: String) -> Void)?
    var clearButtonClickEvent:(() -> Void)?
    var textDidEndEditing: ((_ text: String) -> Void)?
    var textDidBeginEditing: ((_ text: String) -> Void)?
    var updateTableView:((_ textView: UITextView) -> Void)?
    var maxLength = 100

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        placeHolderLabel.isHidden = false
        dataTextView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension RSVPCell {
    
    func setup(isEmpty: Bool) {
        if isEmpty {
            placeHolderLabel.font = UIFont.regular(sz: 17.0)
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
        }
    }
    
    func setup(titleText: String) {
        titleLabel.text = titleText
    }
    
    func setup(dataTextViewText: String) {
        dataTextView.text = dataTextViewText
    }
    
    func setup(isHideClearButton: Bool) {
        clearButton.isHidden = isHideClearButton
    }
    
    @IBAction func clearButtonAction() {
        clearButtonClickEvent?()
    }
}

extension RSVPCell: UITextViewDelegate {
    
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
