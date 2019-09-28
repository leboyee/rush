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
        return section == 0 ? ((Utils.navigationHeigh*2) + 24 + 216) : 44
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return (section == 0 || section == 1 || section == 2) ? 1 : CGFloat.leastNormalMagnitude
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? (indexPath.row == 1 ? 56 : UITableView.automaticDimension) : indexPath.section == 1 ? 112 : indexPath.section == 2 ? 88 : 157
    }
    
    func cellCount(_ section: Int) -> Int {
        return section == 0 ? (isShowMessageButton ? 2 : 1) : 1
    }
    
    func fillManageCell(_ cell: ClubManageCell, _ indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            // For test
            cell.setup(secondButtonType: .message)
            cell.setup(topConstraint: 0)
            
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
            guard let unself = self else { return }
            unself.isShowMessageButton = false
            if unself.friendType == .none {
                unself.friendType = .friends
            } else if unself.friendType == .friends {
                unself.friendType = .addFriend
                
                let snackbar = TTGSnackbar(message: "You unfriended Jessica O'Hara",
                                           duration: .middle,
                                           actionText: "Undo",
                                           actionBlock: { (_) in
                                            unself.friendType = .friends
                                            unself.tableView.reloadData()
                })
                snackbar.show()
                
                /*
                self_.navigationController?.popViewController(animated: true)
                DispatchQueue.main.async {
                    self_.delegate?.unfriendUser("Jessica O'Hara")
                }
                */
            } else if unself.friendType == .addFriend {
                unself.friendType = .requested
            } else if unself.friendType == .requested {
                unself.isShowMessageButton = true
                unself.friendType = .accept
            } else if unself.friendType == .accept {
                unself.friendType = .friends
            }
            unself.tableView.reloadData()
        }
        
        cell.secondButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            if unself.friendType == .accept {
                unself.friendType = .addFriend
                unself.isShowMessageButton = false
                unself.tableView.reloadData()
            } else {
                Utils.notReadyAlert()
            }
        }
    }
    
    func fillEventCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        cell.setup(.none, nil, nil)
        switch indexPath.section {
        case 1:
            cell.setup(imagesList: [])
        case 2:
            cell.setup(userList: [])
        case 3:
            cell.setup(.upcoming, nil, nil)
        case 4:
            cell.setup(.clubs, nil, nil)
        case 5:
            cell.setup(.classes, nil, nil)
        default:
            cell.setup(.none, nil, nil)
        }
        
        cell.cellSelected = { [weak self] (type, id, index) in
            guard let unself = self else { return }
            if indexPath.section == 2 {
                unself.performSegue(withIdentifier: Segues.profileInformation, sender: nil)
            }
        }
    }
    
    func fillImagesCell(_ cell: ProfileImageCell, _ indexPath: IndexPath) {
        
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        
        var text = section == 0 ? "" : section == 1 ? Text.images : section == 2 ? Text.friends : section == 3 ? Text.events : section == 4 ? Text.clubs : section == 5 ? Text.classes : ""
        
        text = (section == 3 && friendType != .friends) ? Text.UpcomingEvents : text
        header.setup(title: text)
        
        header.detailButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            if section == 2 {
                 unself.performSegue(withIdentifier: Segues.friendList, sender: UserProfileDetailType.friends)
            } else if section == 3 {
                unself.performSegue(withIdentifier: Segues.friendList, sender: UserProfileDetailType.events)
            } else if section == 4 {
                unself.performSegue(withIdentifier: Segues.friendList, sender: UserProfileDetailType.clubs)
            } else if section == 5 {
                unself.performSegue(withIdentifier: Segues.friendList, sender: UserProfileDetailType.classes)
            }
        }
    }
    
    func fillImageHeader(_ view: UserImagesHeaderView) {
        view.setup(image: clubImage)
        view.setup(isHideUsernameView: false)
        view.addPhotoButtonEvent = { () in
        }
        
        view.infoButtonEvent = { [weak self] () in
            guard let unself = self else { return }
            unself.performSegue(withIdentifier: Segues.profileInformation, sender: nil)
        }
    }
}

// Services
extension OtherUserProfileController {
    
    func getProfileAPI() {
        let param = [Keys.profileUserId: userInfo?.userId ?? "0"]
        ServiceManager.shared.getProfile(params: param) { [weak self] (data, _) in
            if let object = data?[Keys.user] as? [String: Any] {
                self?.userInfo = Authorization.shared.profileModelResponse(data: object)
            }
            self?.tableView.reloadData()
        }
    }
}
