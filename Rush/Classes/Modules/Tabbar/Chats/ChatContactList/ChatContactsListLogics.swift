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
        if let data = friendsList[alpha.lowercased()] as? [User] {
            return data.count
        } else {
            return 0
        }
    }
    
    func fillCell(_ cell: PeopleCell, _ indexPath: IndexPath) {
        let alpha = alphabet[indexPath.section]
        let users = friendsList[alpha.lowercased()] as? [User]
        let user = users?[indexPath.row]
        cell.setup(title: user?.name ?? "")
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        let alpha = alphabet[indexPath.section]
        let users = friendsList[alpha.lowercased()] as? [User]
        let user = users?[indexPath.row]
        let controller = ChatRoomViewController()
        controller.isShowTempData = false
        controller.friendProfile = user as? Friend
        controller.userName = user?.name ?? ""
        controller.isGroupChat = false
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
        params[Keys.profileUserId] = "5d5d207139277643e20f9bee"//Authorization.shared.profile?.userId
        
        ServiceManager.shared.fetchFriendsList(params: params) { [weak self] (data, _) in
            guard let unsafe = self else { return }
            Utils.hideSpinner()
            
            if unsafe.pageNo == 1 {
                unsafe.friendsList.removeAll()
            }
            
            if let list = data?[Keys.list] as? [[String: Any]] {
                if list.count > 0 {
                    var users = [User]()
                    
                    for object in list {
                        let value = object[Keys.user] as? [String: Any] ?? [:]
                        let user = Authorization.shared.getUser(data: value) //***
                        users.append(user)
                        if let first = user.firstName {
                            if let value = unsafe.friendsList[first.description.lowercased()]  as? [User] {
                                let filter = value.filter { $0.userId == user.userId }
                                if filter.count == 0 {
                                    var tempUser = [User]()
                                    tempUser.append(contentsOf: value)
                                    tempUser.append(user)
                                    unsafe.friendsList[first.description.lowercased()] = tempUser
                                }
                            } else {
                                unsafe.friendsList[first.description.lowercased()] = [user]
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
            unsafe.tableView.reloadData()
        }
    }
}
