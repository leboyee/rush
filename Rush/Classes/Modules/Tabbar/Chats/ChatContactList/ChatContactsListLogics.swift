//
//  ContactsListLogics.swift
//  Rush
//
//  Created by ideveloper on 17/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import SendBirdSDK

extension ChatContactsListViewController {
    
    func cellCount(_ section: Int) -> Int {
        let alpha = alphabet[section]
        if let data = friendsList[alpha.lowercased()] as? [Friend] {
            return data.count
        } else {
            return 0
        }
    }
    
    func fillCell(_ cell: PeopleCell, _ indexPath: IndexPath) {
        let alpha = alphabet[indexPath.section]
        let users = friendsList[alpha.lowercased()] as? [Friend]
        let friend = users?[indexPath.row]
        
        if isDarkModeOn {
            cell.setup(titleColor: .white)
        }
        
        cell.setup(title: friend?.user?.name ?? "")
        if isFromChat {
            cell.setup(url: URL(string: friend?.user?.gender ?? ""))
        } else {
            cell.setup(url: friend?.user?.photo?.url())
        }
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        
        let alpha = alphabet[indexPath.section]
        let users = friendsList[alpha.lowercased()] as? [Friend]
        guard let friend = users?[indexPath.row] else { return }
        
        if isOpenToShare {
            checkIsChatExistOrNot(friend)
        } else {
            let controller = ChatRoomViewController()
            controller.friendProfile = friend
            controller.userName = friend.user?.name ?? ""
            controller.isGroupChat = false
            controller.chatDetailType = .single
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func loadMoreCell(_ indexPath: IndexPath) {
        if indexPath.row == (friendsList.count - 2) && isNextPageExist {
            getFriendListAPI()
        }
    }
    
    func checkIsChatExistOrNot(_ friend: Friend) {
        Utils.showSpinner()
        ChatManager().getListOfFilterGroups(name: "", type: "single", userId: friend.user?.userId ?? "", { [weak self] (data) in
            guard let unsafe = self else { return }
            
            if let channels = data as? [SBDGroupChannel], channels.count > 0 {
                unsafe.shareEvent(channels.first)
            } else {
                Utils.hideSpinner()
                unsafe.createChatAndSharedEvent(friend)
            }
            }, errorHandler: { (error) in
                Utils.hideSpinner()
                print(error?.localizedDescription ?? "")
        })
    }
    
    func createChatAndSharedEvent(_ friend: Friend) {
        let loggedInUserId = Authorization.shared.profile?.userId ?? ""
        let loggedInUserName = Authorization.shared.profile?.name ?? ""
        let loggedInUserImg = Authorization.shared.profile?.photo?.thumb ?? ""
        var totalUserIds = [String]()
        
        let otherUserId = friend.user?.userId ?? "0"
        let imgUrl = (friend.user?.photo?.thumb ?? "") + "," + loggedInUserImg
        let grpName = (friend.user?.name ?? "") + ", " + loggedInUserName
        let type = "single"
        let data = friend.user?.userId ?? "0"
        totalUserIds.append(otherUserId)
        totalUserIds.append(loggedInUserId)
        
        ChatManager().createGroupChannelwithUsers(userIds: totalUserIds, groupName: grpName, coverImageUrl: imgUrl, data: data, type: type, completionHandler: { (channel1) in
            Utils.hideSpinner()
            DispatchQueue.main.async(execute: {
                    // Move on Chat detail screen
                    if channel1?.members?.count == totalUserIds.count - 1 {
                        // channel created
                        self.shareEvent(channel1)
                    } else {
                        var channelUserIds = [String]()
                        if let members = channel1?.members {
                            for member in members {
                                if let user = member as? SBDUser {
                                    channelUserIds.append(user.userId)
                                }
                            }
                        }
                        var filteredIds = [String]()
                        for filterId in totalUserIds {
                            if channelUserIds.contains(filterId) == false {
                                filteredIds.append(filterId)
                            }
                        }
                        
                        if filteredIds.count > 0 {
                            ChatManager().updateChannel(channel: channel1, userIds: filteredIds, groupName: grpName, coverImageUrl: imgUrl, data: data, type: type, completionHandler: { (channel2) in
                                // channel created
                                self.shareEvent(channel2)
                            }, errorHandler: { (_) in
                                print("SOMETHING WRONG IN UPDATE USER IN NEW CHANNEL")
                            })
                        } else {
                            // channel created
                            self.shareEvent(channel1)
                        }
                    }
                })
        }, errorHandler: {_ in
            print("SOMETHING WRONG IN CREATE NEW CHANNEL")
        })
    }
    
    func shareEvent(_ channel: SBDGroupChannel?) {
        
        if let event = sharedEvent {
            let month = event.start?.toString(format: "MMM").uppercased() ?? ""
            let datelable = event.start?.toString(format: "dd") ?? ""
            let day = event.start?.toString(format: "EEEE") ?? ""
            var time = event.start?.toString(format: "hh:mma") ?? ""
            if let endDate = event.end {
                time +=  "-" +  endDate.toString(format: "hh:mma")
            }
            
            let jsonString = "{\"JSON_CHAT\":{\"type\":1,\"eventId\":\"\(event.id)\",\"eventTitle\":\"\(event.title)\",\"eventImage\":\"\(event.photo?.main ?? "")\",\"desc\":\"\(event.desc)\",\"date\":\"\(datelable)\",\"month\":\"\(month)\",\"day\":\"\(day)\",\"time\":\"\(time)\"}}"
            
            let textE = "shared \(event.title) with you."
            
            ChatManager().sendEventMessage(textE, data: jsonString, channel: channel, completionHandler: { (message) in
                if message != nil {
                    self.delegate?.sharedResult(flg: true)
                } else {
                    self.delegate?.sharedResult(flg: false)
                }
                self.navigationController?.popViewController(animated: false)
            }, errorHandler: { (_) in
                self.delegate?.sharedResult(flg: false)
                self.navigationController?.popViewController(animated: false)
            })
        }
    }
}

// MARK: - Services
extension ChatContactsListViewController {
    func getFriendListAPI() {
        
        if pageNo == 1 { friendsList.removeAll() }
        
        var params = [Keys.pageNo: "\(pageNo)"]
        params[Keys.search] = searchText
        params[Keys.profileUserId] = Authorization.shared.profile?.userId
        
        ServiceManager.shared.fetchFriendsList(params: params) { [weak self] (data, _, _) in
            guard let unsafe = self else { return }
            Utils.hideSpinner()
            
            if unsafe.pageNo == 1 {
                unsafe.friendsList.removeAll()
            }
            
            if let list = data {
                if list.count > 0 {
                    var users = [Friend]()
                    
                    for object in list {
                        users.append(object)
                        if let first = object.user?.firstName?.first {
                            if let value = unsafe.friendsList[first.description.lowercased()]  as? [Friend] {
                                let filter = value.filter { $0.user?.userId == object.user?.userId }
                                if filter.count == 0 {
                                    var tempUser = [Friend]()
                                    tempUser.append(contentsOf: value)
                                    tempUser.append(object)
                                    unsafe.friendsList[first.description.lowercased()] = tempUser
                                }
                            } else {
                                unsafe.friendsList[first.description.lowercased()] = [object]
                            }
                        }
                    }
                    
                    if unsafe.pageNo == 1 {
                        unsafe.tempFriendsList = users
                    } else {
                        unsafe.tempFriendsList.append(contentsOf: users)
                    }
                    unsafe.pageNo += 1
                    unsafe.isNextPageExist = true
                } else {
                    unsafe.isNextPageExist = false
                    if unsafe.pageNo == 1 {
                        unsafe.tempFriendsList.removeAll()
                    }
                }
            }
            
            if unsafe.tempFriendsList.count > 0 {
                unsafe.noDataFound.isHidden = true
            } else {
                unsafe.noDataFound.isHidden = false
            }
            
            unsafe.tableView.reloadData()
        }
    }
}
