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
        let status = userInfo?.friendTypeStatus ?? .none
        
        if indexPath.row == 0 {
            
            // For test
            cell.setup(secondButtonType: .message)
            cell.setup(topConstraint: 0)
            if status == .none {
                
            } else if status == .friends {
                cell.setup(firstButtonType: .friends)
                isShowMessageButton = false
            } else if status == .requested {
                cell.setup(firstButtonType: .requested)
                isShowMessageButton = false
            } else if status == .accept {
                cell.setup(firstButtonType: .accept)
                cell.setup(secondButtonType: .reject)
                isShowMessageButton = true
            } else if status == .addFriend {
                cell.setup(firstButtonType: .addFriend)
            }
        } else {
            cell.setup(secondButtonType: .message)
            cell.setup(isOnlyShowMessage: true)
        }
        
        cell.firstButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            unself.isShowMessageButton = false
            if status == .none {
                unself.friendType = .friends
            } else if status == .friends {
                //unself.friendType = .addFriend
                
                Utils.alert(message: "Are you sure you want to unfriend of \(unself.userInfo?.name ?? "").", buttons: ["Yes", "No"], handler: { (index) in
                    if index == 0 {
                        unself.moderateFriendRequestAPI(type: "unfriend")
                    }
                })
                
                /*
                 self_.navigationController?.popViewController(animated: true)
                 DispatchQueue.main.async {
                 self_.delegate?.unfriendUser("Jessica O'Hara")
                 }
                 */
            } else if status == .addFriend {
                // unself.friendType = .requested
                Utils.alert(message: "Are you sure you want to send friend request to \(unself.userInfo?.name ?? "").", buttons: ["Yes", "No"], handler: { (index) in
                    if index == 0 {
                        unself.sendFriendRequestAPI()
                    }
                })
            } else if status == .requested {
                //unself.isShowMessageButton = true
                //unself.friendType = .accept
            } else if status == .accept {
                // unself.friendType = .friends
                Utils.alert(message: "Are you sure you want to accept friend request of \(unself.userInfo?.name ?? "").", buttons: ["Yes", "No"], handler: { (index) in
                    if index == 0 {
                        unself.moderateFriendRequestAPI(type: "accept")
                    }
                })
            }
            unself.tableView.reloadData()
        }
        
        cell.secondButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            if status == .accept {
                /*
                unself.friendType = .addFriend
                unself.isShowMessageButton = false
                unself.tableView.reloadData()
                */
                Utils.alert(message: "Are you sure you want to reject friend request of \(unself.userInfo?.name ?? "").", buttons: ["Yes", "No"], handler: { (index) in
                    if index == 0 {
                        unself.moderateFriendRequestAPI(type: "decline")
                    }
                })
            } else {
                let controller = ChatRoomViewController()
                controller.isShowTempData = false
                controller.userName = unself.userInfo?.name ?? ""
                unself.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func fillEventCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        cell.setup(.none, nil, nil)
        switch indexPath.section {
        case 1:
            cell.setup(imagesList: [])
        case 2:
            cell.setup(invitees: [])
        case 3:
            cell.setup(.upcoming, nil, eventList)
        case 4:
            cell.setup(.clubs, nil, clubList)
        case 5:
            cell.setup(.classes, nil, classList)
        default:
            cell.setup(.none, nil, nil)
        }
        
        cell.cellSelected = { [weak self] (type, id, index) in
            guard let unsafe = self else { return }
            if indexPath.section == 2 {
                unsafe.performSegue(withIdentifier: Segues.profileInformation, sender: nil)
            } else if indexPath.section == 3 {
                let event = unsafe.eventList[index]
                unsafe.performSegue(withIdentifier: Segues.otherProfileEventDetail, sender: event)
            } else if type == .clubs {
                let club = unsafe.clubList[index]
                unsafe.performSegue(withIdentifier: Segues.clubDetailSegue, sender: club)
            } else if type == .classes {
                let club = unsafe.classList[index]
                unsafe.performSegue(withIdentifier: Segues.classDetailSegue, sender: club)
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
        view.setup(userInfo: userInfo)
        view.universtityLabel.isHidden = false
        
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
        ServiceManager.shared.getProfile(params: param) { [weak self] (user, _) in
            self?.userInfo = user
            self?.tableView.reloadData()
        }
    }
    
    func getClubListAPI(sortBy: String) {
        
        let param = [Keys.search: searchText,
                     Keys.sortBy: sortBy,
                     Keys.pageNo: pageNo] as [String: Any]
        
        if clubList.count == 0 {
            Utils.showSpinner()
        }
        
        ServiceManager.shared.fetchClubList(sortBy: sortBy, params: param) { [weak self] (value, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let clubs = value {
                unsafe.clubList = clubs
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func getEventList(sortBy: GetEventType) {
        
        let param = [Keys.profileUserId: Authorization.shared.profile?.userId ?? "",
                     Keys.search: searchText,
                     Keys.sortBy: sortBy.rawValue,
                     Keys.pageNo: pageNo] as [String: Any]
        
        ServiceManager.shared.fetchEventList(sortBy: sortBy.rawValue, params: param) { [weak self] (value, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let events = value {
                unsafe.eventList = events
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func getClassCategoryAPI() {
        let param = [Keys.pageNo: pageNo] as [String: Any]
        
        ServiceManager.shared.fetchCategoryClassList(params: param) { [weak self] (data, errorMsg) in
            guard let unsafe = self else { return }
            if let classes = data {
                unsafe.classList = classes
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func sendFriendRequestAPI() {
        
        let param = [Keys.otherUserId: userInfo?.id ?? "0"]
        ServiceManager.shared.sendFriendRequest(params: param) { [weak self] (status, errorMsg) in
            guard let unsafe = self else { return }
            if status {
                unsafe.getProfileAPI()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func moderateFriendRequestAPI(type: String) {
        
        let param = [Keys.otherUserId: userInfo?.id ?? "0",
                     Keys.action: type]
        ServiceManager.shared.moderateFriendRequest(params: param) { [weak self] (status, errorMsg) in
            guard let unsafe = self else { return }
            if status {
                if type == "unfriend" {
                    let snackbar = TTGSnackbar(message: "You unfriended \(String(describing: self?.userInfo?.name))",
                        duration: .middle,
                        actionText: "Undo",
                        actionBlock: { (_) in
                           Utils.notReadyAlert()
                    })
                    snackbar.show()
                }
                unsafe.getProfileAPI()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
