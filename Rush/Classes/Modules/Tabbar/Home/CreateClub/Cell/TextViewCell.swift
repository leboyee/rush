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
    @IBOutlet weak var topPlaceHolderConstraint: NSLayoutConstraint!
    @IBOutlet weak var topTextViewConstraint: NSLayoutConstraint!
    
    var maxLength = 300
    var textDidEndEditing: ((_ text : String) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Configure the view for the selected state
        textView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

extension TextViewCell {
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
    
    func setup(text: String) {
        textView.text = text
        setup(isEmpty: text.isEmpty)
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
        
    }
}
