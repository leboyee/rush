//
//  PostPresenter.swift
//  Rush
//
//  Created by ideveloper on 25/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension PostViewController {
    
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
        
        cell.setup(text: "It’s so great to see you guys! I hope we’ll have a great day :)", placeholder: "")
        cell.setup(font: UIFont.Regular(sz: 17))
        
    }
    
    // Image cell (section 2)
    func fillImageCell(_ cell: UserPostImageTableViewCell, _ indexPath: IndexPath) {
        cell.setup(imageAsset: imageList[indexPath.row])
        cell.setup(isCleareButtonHide: true)
    }
    
    func fillTextHeader(_ header: TextHeader,_ section: Int) {
        header.setup(title: Text.comments)
        header.setup(isDetailArrowHide: true)
    }
}

