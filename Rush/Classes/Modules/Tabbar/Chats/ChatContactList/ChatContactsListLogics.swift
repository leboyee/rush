//
//  ContactsListLogics.swift
//  Rush
//
//  Created by ideveloper on 17/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

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
        let friend = users?[indexPath.row]
        
        let controller = ChatRoomViewController()
        controller.friendProfile = friend
        controller.userName = friend?.user?.name ?? ""
        controller.isGroupChat = false
        controller.chatDetailType = .single
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func loadMoreCell(_ indexPath: IndexPath) {
        if indexPath.row == (friendsList.count - 2) && isNextPageExist {
            getFriendListAPI()
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
