//
//  UserPostTextTableViewCell.swift
//  Rush
//
//  Created by ideveloper2 on 12/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class UserPostTextTableViewCell: UITableViewCell {


    @IBOutlet weak var postTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postTextView.delegate = self
        postTextView.text = Text.saysomething
//        postTextView.translatesAutoresizingMaskIntoConstraints = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
extension UserPostTextTableViewCell :UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == Text.saysomething {
            textView.text = ""
        }
        return true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.gray
            textView.text = Text.saysomething
        }
    }
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    
}
