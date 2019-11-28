//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

extension MyClubViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        if section == 0 {
            // Navigaiton height + cornerRadius height + changePhotoLabelOrigin
            return ((Utils.navigationHeigh*2) + 24 + 216)
        } else if section == 1 {
            return CGFloat.leastNormalMagnitude
        } else {
            return 44
        }
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 1
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 2 ? 88 : indexPath.section == 4 ? 48 : UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        if section == 2 {
            return (interestList?.count ?? 0) + 1
        } else if section == 3 {
            return peopleList.count + 1
        }
        return 1
    }
    
    func fillClubNameCell(_ cell: ClubNameCell) {
        cell.setup(isHideReadmoreButton: true)
    }
    
    func fillJoinedUserCell(_ cell: EventTypeCell) {
        cell.setup(invitees: [], total: 0)
        
        cell.cellSelected = { [weak self] (type, id, index) in
            guard let unself = self else { return }
            if index != 0 { // User profile
                unself.performSegue(withIdentifier: Segues.otherUserProfile, sender: nil)
            } else { // Open user list
//                Utils.notReadyAlert()
            }
        }
    }
    
    func fillTagCell(_ cell: TagCell) {
        cell.setup(tagList: ["ABC", "DEF", "TYU", "HDGHJKDHD", "DLHDDDHKD"])
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(isDetailArrowHide: true)
        if section == 2 {
            header.setup(title: Text.joined)
        } else if section == 3 {
            header.setup(title: Text.interestTag)
        } else if section == 4 {
            header.setup(title: Text.posts)
        }
    }
    
    func fillImageHeader(_ view: UserImagesHeaderView) {
        view.setup(image: clubImage)
        view.setup(isHideHoverView: true)
    }
}

extension MyClubViewController {
    
}
