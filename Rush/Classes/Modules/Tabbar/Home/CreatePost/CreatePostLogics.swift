//
//  CreatePostLogics.swift
//  Rush
//
//  Created by ideveloper2 on 12/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos


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
            
            let numLines = Int((Float(textView.contentSize.height / (textView.font?.lineHeight ?? 0))))
            
            if self_.bigFontCount != 0 && self_.bigFontCount <= textView.text.count {
                cell.setup(font: UIFont.regular(sz: 17))
            } else {
                if numLines >= 3 {
                    self_.bigFontCount = textView.text.count
                    cell.setup(font: UIFont.regular(sz: 17))
                } else {
                    cell.setup(font: UIFont.displayBold(sz: 28))
                }
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
            self_.createButtonValidation()
        }
    }
    
    // Image cell (section 2)
    func fillImageCell(_ cell: UserPostImageTableViewCell, _ indexPath: IndexPath) {
        let asset = imageList[indexPath.row]
        cell.setup(imageAsset: asset)
        
        cell.clearButtonClickEvent = { [weak self] () in
            guard let self_ = self else { return }
            self_.imageList.remove(at: indexPath.row)
            self_.tableView.reloadData()
        }
    }
}

