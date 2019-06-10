//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

extension OtherUserProfileController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return section == 0 ? CGFloat(CFloat.leastNormalMagnitude) : 44
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return (section == 0 || section == 1 || section == 2) ? 1 : 0
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? (indexPath.row == 1 ? 56 : UITableView.automaticDimension) : indexPath.section == 1 ? 112 : indexPath.section == 2 ? 88 : 157
    }
    
    func cellCount(_ section: Int) -> Int {
        return section == 0 ? (isShowMessageButton ? 2 : 1) : 1
    }
    
    func fillManageCell(_ cell: ClubManageCell,_ indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            // For test
            cell.setup(secondButtonType: .message)
            if friendType == .none {
                
            } else if friendType == .friends {
                cell.setup(firstButtonType: .friends)
                isShowMessageButton = false
            } else if friendType == .requested {
                cell.setup(firstButtonType: .requested)
                isShowMessageButton = false
            } else if friendType == .accept {
                cell.setup(firstButtonType: .accept)
                cell.setup(secondButtonType: .reject)
                isShowMessageButton = true
            } else if friendType == .addFriend {
                cell.setup(firstButtonType: .addFriend)
            }
        } else {
            cell.setup(secondButtonType: .message)
            cell.setup(isOnlyShowMessage: true)
        }
        
        cell.firstButtonClickEvent = { [weak self] () in
            guard let self_ = self else { return }
            self_.isShowMessageButton = false
            if self_.friendType == .none {
                self_.friendType = .friends
            } else if self_.friendType == .friends {
                self_.friendType = .addFriend
                self_.performSegue(withIdentifier: Segues.notificationAlert, sender: "You unfriended Jessica O'Hara")
            } else if self_.friendType == .addFriend {
                self_.friendType = .requested
            } else if self_.friendType == .requested {
                self_.isShowMessageButton = true
                self_.friendType = .accept
            } else if self_.friendType == .accept {
                self_.friendType = .friends
            }
            self_.tableView.reloadData()
        }
        
        cell.secondButtonClickEvent = { [weak self] () in
            guard let self_ = self else { return }
            if self_.friendType == .accept {
                self_.friendType = .addFriend
                self_.isShowMessageButton = false
                self_.tableView.reloadData()
            } else {
                Utils.notReadyAlert()
            }
        }
    }
    
    func fillEventCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        cell.setup(.none, nil)
        switch indexPath.section {
        case 1:
            cell.setup(imagesList: [])
        case 2:
            cell.setup(userList: [])
        case 3:
            cell.setup(.upcoming, nil)
        case 4:
            cell.setup(.clubs, nil)
        case 5:
            cell.setup(.classes, nil)
        default:
            cell.setup(.none, nil)
            break
        }
    }
    
    func fillImagesCell(_ cell: ProfileImageCell, _ indexPath: IndexPath) {
        
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        
        let text = section == 0 ? "" : section == 1 ? Text.images : section == 2 ? Text.friends : section == 3 ? Text.events : section == 4 ? Text.clubs : section == 5 ? Text.classes : ""
        header.setup(title: text)
        
        header.detailButtonClickEvent = { [weak self] () in
            guard let self_ = self else { return }
            if section == 2 {
                 self_.performSegue(withIdentifier: Segues.friendList, sender: UserProfileDetailType.friends)
            } else if section == 3 {
                self_.performSegue(withIdentifier: Segues.friendList, sender: UserProfileDetailType.events)
            } else if section == 4 {
                self_.performSegue(withIdentifier: Segues.friendList, sender: UserProfileDetailType.clubs)
            } else if section == 5 {
                self_.performSegue(withIdentifier: Segues.friendList, sender: UserProfileDetailType.classes)
            }
        }
    }
}

extension OtherUserProfileController {
    
}
