//
//  CreatePostLogics.swift
//  Rush
//
//  Created by ideveloper2 on 12/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension CreatePostViewController {
    
    func cellHeight(_ indexPath:IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return screenWidth
        } else {
            return UITableView.automaticDimension
        }
    }
    
    // Username cell (section 0)
    func userDetailCell(_ cell: UserNameTableViewCell) {
        
    }
    
    // Textview cell (section 1)
    func fillTextViewCell(_ cell: UserPostTextTableViewCell) {
        
        cell.updateTableView = {
            [weak self] (textView) in
            guard let self_ = self else { return }
            
            self_.postText = textView.text
            
            let startHeight = textView.frame.size.height
            var calcHeight = textView.sizeThatFits(textView.frame.size).height
            if calcHeight == startHeight && textView.text.isEmpty {
                calcHeight = calcHeight + 1
            }
            if startHeight != calcHeight {
                // Disable animations
                UIView.setAnimationsEnabled(false)
                self_.tableView.beginUpdates()
                self_.tableView.endUpdates()
                // Enable animations
                UIView.setAnimationsEnabled(true)
            }
        }
        
        cell.textDidEndEditing = {
            [weak self] () in
            guard let self_ = self else { return }
            if self_.postText.isNotEmpty {
                // Update create post button
            }
        }
    }
    
    // Image cell (section 2)
    func fillImageCell(_ cell: UserPostImageTableViewCell, _ indexPath: IndexPath) {
        cell.postImageView.image = imageList[indexPath.row]
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            viewBottamConstraint.constant = keyboardSize.size.height + 40
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        viewBottamConstraint.constant = 20
    }
}

