//
//  UserPostTextTableViewCell.swift
//  Rush
//
//  Created by ideveloper2 on 12/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class UserPostTextTableViewCell: UITableViewCell {


    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    var textDidEndEditing:(() -> Void)?
    var updateTableView:((_ textView: UITextView) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        postTextView.delegate = self
        postTextView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

// MARK: - TextView delegate methods
extension UserPostTextTableViewCell :UITextViewDelegate {
        
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            placeHolderLabel.isHidden = true
        } else {
            placeHolderLabel.isHidden = false
        }
        updateTableView?(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textDidEndEditing?()
    }
}
