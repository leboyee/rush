//
//  JoinRSVPCell.swift
//  Rush
//
//  Created by kamal on 17/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class JoinRSVPCell: UITableViewCell {

    @IBOutlet weak var textView: CustomBlackTextView!
    @IBOutlet weak var titleLabel: CustomBlackLabel!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var separatorView: RSeparatorLine!
    
    var textDidChanged: ((_ text: String) -> Void)?
    var textDidEndEditing: ((_ text: String) -> Void)?
    var textDidBeginEditing: ((_ text: String) -> Void)?
    var maxLength = 150
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Data
extension JoinRSVPCell {
    
    func setup(question: String) {
        titleLabel.text = question
    }
    
    func setup(placeholder: String) {
        placeHolderLabel.text = placeholder
    }
    
    func setup(answer: String) {
        textView.text = answer
        setup(isEmpty: answer.isEmpty)
    }
    
    func setup(isEmpty: Bool) {
        if isEmpty {
            setup(question: "")
            placeHolderLabel.isHidden = false
        } else {
            setup(question: placeHolderLabel.text ?? "")
            placeHolderLabel.isHidden = true
        }
    }
}

extension JoinRSVPCell: UITextViewDelegate {
    
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
    }
}
