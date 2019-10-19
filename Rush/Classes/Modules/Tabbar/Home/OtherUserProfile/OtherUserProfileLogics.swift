//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos
import SendBirdSDK

extension OtherUserProfileController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        if section == 0 {
            return ((Utils.navigationHeigh*2) + 24 + 216)
        } else if (section == 1 && imagesList.count > 0) || (section == 2 && friendList.count > 0) || (section == 3 && eventList.count > 0) || (section == 4 && clubList.count > 0) || (section == 5 && classList.count > 0) {
            return 44
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        
        if section == 0 || (section == 1 && imagesList.count > 0) || (section == 2 && friendList.count > 0) {
            return 1
        } else if section == 5 {
            return 50
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return indexPath.row == 1 ? 56 : UITableView.automaticDimension
        } else if indexPath.section == 1 {
            return imagesList.count > 0 ? 112 : CGFloat.leastNormalMagnitude
        } else if indexPath.section == 2 {
            return friendList.count > 0 ? 88 : CGFloat.leastNormalMagnitude
        } else if (indexPath.section == 3 && eventList.count > 0) || (indexPath.section == 4 && clubList.count > 0) || (indexPath.section == 5 && classList.count > 0) {
            return 157
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func cellCount(_ section: Int) -> Int {
        return section == 0 ? (isShowMessageButton ? 2 : 1) : 1
    }
    
    func fillManageCell(_ cell: ClubManageCell, _ indexPath: IndexPath) {
        let status = userInfo?.friendTypeStatus ?? .none
        
        if indexPath.row == 0 {
            
            cell.setup(secondButtonType: .message)
            cell.setup(topConstraint: 0)
            isShowMessageButton = false
            if status == .none {
                
            } else if status == .friends {
                cell.setup(firstButtonType: .friends)
            } else if status == .requested {
                cell.setup(firstButtonType: .requested)
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
                
                Utils.alert(message: "Are you sure you want to unfriend  \(unself.userInfo?.name ?? "")?", buttons: ["Yes", "No"], handler: { (index) in
                    if index == 0 {
                        unself.moderateFriendRequestAPI(type: "unfriend")
                    }
                })
            } else if status == .addFriend {
                // unself.friendType = .requested
                Utils.alert(message: "Are you sure you want to send friend request to \(unself.userInfo?.name ?? "")?", buttons: ["Yes", "No"], handler: { (index) in
                    if index == 0 {
                        unself.sendFriendRequestAPI()
                    }
                })
            } else if status == .requested {
                //unself.isShowMessageButton = true
                //unself.friendType = .accept
            } else if status == .accept {
                // unself.friendType = .friends
                Utils.alert(message: "Are you sure you want to accept friend request of \(unself.userInfo?.name ?? "")?", buttons: ["Yes", "No"], handler: { (index) in
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
                Utils.alert(message: "Are you sure you want to reject friend request of \(unself.userInfo?.name ?? "")?", buttons: ["Yes", "No"], handler: { (index) in
                    if index == 0 {
                        unself.moderateFriendRequestAPI(type: "decline")
                    }
                })
            } else {
                unself.checkIsChatExistOrNot()
            }
        }
    }
    
    func checkIsChatExistOrNot() {
        Utils.showSpinner()
        ChatManager().getListOfFilterGroups(name: "", type: "single", userId: userInfo?.userId ?? "", { [weak self] (data) in
            guard let unsafe = self else { return }
            Utils.hideSpinner()
            let controller = ChatRoomViewController()
            controller.isGroupChat = false
            controller.chatDetailType = .single
            controller.userName = unsafe.userInfo?.name ?? ""
            controller.hidesBottomBarWhenPushed = true
            let friend = Friend()
            friend.user = unsafe.userInfo
            controller.friendProfile = friend
            controller.hidesBottomBarWhenPushed = true
            
            if let channels = data as? [SBDGroupChannel], channels.count > 0 {
                controller.channel = channels.first
            }
            unsafe.navigationController?.pushViewController(controller, animated: true)
        }, errorHandler: { (error) in
            print(error?.localizedDescription ?? "")
        })
    }
    
    func fillEventCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        cell.setup(.none, nil, nil)
        switch indexPath.section {
        case 1:
            cell.setup(imagesList: imagesList)
        case 2:
            cell.setup(friends: friendList)
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
            if indexPath.section == 1 {
                unsafe.performSegue(withIdentifier: Segues.userProfileGallerySegue, sender: nil)
            } else if indexPath.section == 2 {
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
            guard let unsafe = self else { return }
            unsafe.userInfo = user
            unsafe.isShowMessageButton = unsafe.userInfo?.friendTypeStatus == .accept ? true : false
            unsafe.tableView.reloadData()
            unsafe.getFriendListAPI()
        }
    }
    
    func getClubListAPI(sortBy: String) {
        
        let param = [Keys.search: searchText,
                     Keys.sortBy: sortBy,
                     Keys.pageNo: pageNo,
                     Keys.profileUserId: userInfo?.userId ?? "0"] as [String: Any]
        
        if clubList.count == 0 {
            Utils.showSpinner()
        }
        
        ServiceManager.shared.fetchClubList(sortBy: sortBy, params: param) { [weak self] (value, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let clubs = value {
                unsafe.clubList = clubs
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
            unsafe.getMyJoinedClasses(search: "")
        }
    }
    
    func getEventList(sortBy: GetEventType) {
        
        let param = [Keys.profileUserId: userInfo?.userId ?? "0",
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
            unsafe.getClubListAPI(sortBy: "joined")
        }
    }
    
     func getMyJoinedClasses(search: String) {
        //pagination not done
        let param = [Keys.pageNo: pageNoClass, Keys.search: "", Keys.profileUserId: userInfo?.userId ?? "0"] as [String: Any]
        
        ServiceManager.shared.fetchMyJoinedClassList(params: param) { [weak self] (data, _) in
            guard let unsafe = self else { return }
            if unsafe.pageNoClass == 1 {
                unsafe.classList.removeAll()
            }
            if let classes = data, classes.count > 0 {
                if unsafe.pageNoClass == 1 {
                    unsafe.classList = classes
                } else {
                    unsafe.classList += classes
                }
                unsafe.isNextPageClass = true
            } else {
                if unsafe.pageNoClass == 1 || (unsafe.pageNoClass > 1 && data?.count == 0) {
                    unsafe.isNextPageClass = false
                }
            }
               unsafe.tableView.reloadData()
           }
           
       }

    func getFriendListAPI() {
        
        let params = [Keys.pageNo: 1,
                      Keys.search: "",
                      Keys.profileUserId: userInfo?.userId ?? "0"] as [String: Any]
        
        ServiceManager.shared.fetchFriendsList(params: params) { [weak self] (data, _) in
            guard let unsafe = self else { return }
            if let list = data {
                unsafe.friendList = list
                unsafe.tableView.reloadData()
            }
            unsafe.fetchImagesList()
        }
    }
    
    func sendFriendRequestAPI() {
        
        let param = [Keys.otherUserId: userInfo?.userId ?? "0"]
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
        
        let param = [Keys.otherUserId: userInfo?.userId ?? "0",
                     Keys.action: type]
        ServiceManager.shared.moderateFriendRequest(params: param) { [weak self] (status, errorMsg) in
            guard let unsafe = self else { return }
            if status {
                if type == "unfriend" {
                    let snackbar = TTGSnackbar(message: "You unfriended \(unsafe.userInfo?.name ?? "")",
                        duration: .middle,
                        actionText: "",
                        actionBlock: { (_) in
                    })
                    snackbar.show()
                }
                unsafe.getProfileAPI()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    private func fetchImagesList() {
        guard let userId = self.userInfo?.userId else { return }
        let params = [Keys.profileUserId: userId, Keys.pageNo: "1"] as [String: Any]
        ServiceManager.shared.getImageList(params: params, closer: { [weak self] (data, _) in
            guard let unsafe = self else { return }
            if let list = data?[Keys.images] as? [[String: Any]] {
                var items = [Image]()
                for item in list {
                    if let json = item["img_data"] as? String {
                        let image = Image(json: json)
                        items.append(image)
                    }
                }
                unsafe.imagesList = items
            }
            unsafe.getEventList(sortBy: .myUpcoming)
        })
    }
}
