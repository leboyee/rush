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
            return 16
        } else if (section == 1 && (rsvpQuestion?.count ?? 0) > 0) || (section == 2) || (section == 3) || (section == 4) || (section == 5) || (section == 6) {
            return 44
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        
        if section == 0 || (section == 1 && (rsvpQuestion?.count ?? 0) > 0) || (section == 2 && imagesList.count > 0) || (section == 3 && friendList.count > 0) {
            return 1
        } else if section == 6 {
            return 50
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return indexPath.row == 1 ? 56 : UITableView.automaticDimension
        } else if indexPath.section == 1 && (rsvpQuestion?.count ?? 0) > 0 {
            return UITableView.automaticDimension
        } else if indexPath.section == 2 {
            return imagesList.count > 0 ? 112 : UITableView.automaticDimension
        } else if indexPath.section == 3 {
            return friendList.count > 0 ? 88 : UITableView.automaticDimension
        } else if (indexPath.section == 4 && eventList.count > 0) || (indexPath.section == 5 && clubList.count > 0) || (indexPath.section == 6 && classList.count > 0) {
            return 157
        } else if (indexPath.section == 4 && eventList.count == 0) || (indexPath.section == 5 && clubList.count == 0) || (indexPath.section == 6 && classList.count == 0) {
            return UITableView.automaticDimension
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func isShowEmptyPlaceholder(_ section: Int) -> Bool {
        if (section == 2 && imagesList.count == 0) || (section == 3 && friendList.count == 0) || (section == 4 && eventList.count == 0) || (section == 5 && clubList.count == 0) || (section == 6 && classList.count == 0) {
            return true
        }
        return false
    }
    
    func fillPlaceholderCell(_ cell: NoEventsCell, _ section: Int) {
        switch section {
        case 2:
            cell.set(title: Message.noImageAdded)
        case 3:
            cell.set(title: Message.noFriendFound)
        case 4:
            cell.setEvents()
        case 5:
            cell.setClub()
        case 6:
            cell.setClasses()
        default: break
        }
    }
    
    func cellCount(_ section: Int) -> Int {
        return section == 0 ? (isShowMessageButton ? 2 : 1) : section == 1 ? (rsvpQuestion?.count ?? 0) : 1
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
                /*
                if userInfo?.isMessageAllow == 0 {
                    cell.setup(enableMessageButton: false, button: cell.secondButton)
                }
                */
            } else if status == .requested {
                cell.setup(firstButtonType: .requested)
                /*
                if userInfo?.isMessageAllow == 0 {
                    cell.setup(enableMessageButton: false, button: cell.secondButton)
                }
                */
            } else if status == .accept {
                cell.setup(firstButtonType: .accept)
                cell.setup(secondButtonType: .reject)
                isShowMessageButton = true
                
                if userInfo?.isMessageAllow == 0 {
                    cell.setup(enableMessageButton: false, button: cell.messageButton)
                }
                
            } else if status == .addFriend {
                cell.setup(firstButtonType: .addFriend)
                /*
                if userInfo?.isMessageAllow == 0 {
                    cell.setup(enableMessageButton: false, button: cell.secondButton)
                }
                */
            }
            
        } else {
            /*
            if userInfo?.isMessageAllow == 0 {
                cell.setup(enableMessageButton: false, button: cell.secondButton)
            }
            */
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
                if unself.userInfo?.isMessageAllow == 0 {
                    let snackbar = TTGSnackbar(message: "\(unself.userInfo?.name ?? "") has private privacy setting. You can't message.",
                        duration: .middle,
                        actionText: "",
                        actionBlock: { (_) in
                            
                    })
                    snackbar.show()
                } else {
                    unself.checkIsChatExistOrNot()
                }
            }
        }
        
        cell.messageButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            if unself.userInfo?.isMessageAllow == 0 {
                let snackbar = TTGSnackbar(message: "\(unself.userInfo?.name ?? "") has private privacy setting. You can't message.",
                    duration: .middle,
                    actionText: "",
                    actionBlock: { (_) in
                        
                })
                snackbar.show()
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
        case 2:
            cell.setup(imagesList: imagesList)
        case 3:
            cell.setup(friends: friendList)
        case 4:
            cell.setup(.upcoming, nil, eventList)
        case 5:
            cell.setup(.clubs, nil, clubList)
        case 6:
            cell.setup(.classes, nil, classList)
        default:
            cell.setup(.none, nil, nil)
        }
        
        cell.cellSelected = { [weak self] (type, id, index) in
            guard let unsafe = self else { return }
            if indexPath.section == 2 {
                unsafe.performSegue(withIdentifier: Segues.userProfileGallerySegue, sender: Int(index))
            } else if indexPath.section == 3 {
                let friend = unsafe.friendList[index]
                if friend.user?.userId == Authorization.shared.profile?.userId {
                    if unsafe.tabBarController?.selectedIndex == 3 {
                        unsafe.navigationController?.popToRootViewController(animated: true)
                    } else {
                        unsafe.tabBarController?.selectedIndex = 3
                    }
                } else {
                    unsafe.performSegue(withIdentifier: Segues.otherUserProfile, sender: friend.user)
                }
            } else if indexPath.section == 4 {
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
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        
        var text = section == 0 ? "" : section == 1 ? Text.rsvp : section == 2 ? Text.images : section == 3 ? Text.friends : section == 4 ? Text.events : section == 5 ? Text.clubs : section == 6 ? Text.classes : ""
        
        text = (section == 4 && friendType != .friends) ? Text.UpcomingEvents : text
        header.setup(title: text)
        
        if section == 0 || section == 1 {
            header.setup(isDetailArrowHide: true)
        } else {
            header.setup(isDetailArrowHide: false)
        }
        
        header.detailButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            if section == 2 {
                if unself.imagesList.count > 0 {
                    unself.performSegue(withIdentifier: Segues.profileImageViewSegue, sender: nil)
                }
            } else if section == 3 {
                unself.performSegue(withIdentifier: Segues.friendList, sender: UserProfileDetailType.friends)
            } else if section == 4 {
                unself.performSegue(withIdentifier: Segues.friendList, sender: UserProfileDetailType.events)
            } else if section == 5 {
                unself.performSegue(withIdentifier: Segues.friendList, sender: UserProfileDetailType.clubs)
            } else if section == 6 {
                unself.performSegue(withIdentifier: Segues.friendList, sender: UserProfileDetailType.classes)
            }
        }
    }
    
    func fillRsvpQuestionCell(_ cell: QuestionCell, _ indexPath: IndexPath) {
        let question = rsvpQuestion?[indexPath.row]
        cell.set(question: question?.que ?? "")
        
        if (rsvpQuestion?.count ?? 0) - 1 == indexPath.row {
            cell.set(isSeparatorHide: true)
        } else {
            cell.set(isSeparatorHide: false)
        }
        
        if let answerList = rsvpAnswer {
            if answerList.count > indexPath.row {
                let answer = answerList[indexPath.row]
                cell.set(answer: answer.ans)
            } else {
                cell.set(answer: "")
            }
        } else {
            cell.set(answer: "")
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
            unsafe.fillImageHeader()
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
        
        ServiceManager.shared.fetchClubList(sortBy: sortBy, params: param) { [weak self] (value, _, errorMsg) in
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
        
        ServiceManager.shared.fetchEventList(sortBy: sortBy.rawValue, params: param) { [weak self] (value, _, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let events = value {
                unsafe.eventList = events
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
            unsafe.getClubListAPI(sortBy: "my-joined")
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
        
        ServiceManager.shared.fetchFriendsList(params: params) { [weak self] (data, _, _) in
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
            unsafe.getEventList(sortBy: .my)
        })
    }
}
