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
        if let data = friendsList[alpha.lowercased()] as? [Profile] {
            return data.count
        } else {
            return 0
        }
    }
    
    func fillCell(_ cell: PeopleCell, _ indexPath: IndexPath) {
        let alpha = alphabet[indexPath.section]
        let users = friendsList[alpha.lowercased()] as? [Profile]
        let user = users?[indexPath.row]
        cell.setup(title: user?.name ?? "")
    }
    
    func loadMoreCell(_ indexPath: IndexPath) {
        if indexPath.row == (friendsList.count - 2) && isNextPageExist {
            getFriendListAPI()
        }
    }
}

// MARK:- Services
extension ChatContactsListViewController {
    func getFriendListAPI() {
        
        if pageNo == 1 { friendsList.removeAll() }
        
        var params = [Keys.pageNo: "\(pageNo)"]
        params[Keys.search] = searchText
        params[Keys.profileUserId] = "5d5d207139277643e20f9bee"//Authorization.shared.profile?.userId
        
        ServiceManager.shared.fetchFriendsList(params: params) {
            [weak self] (data, errorMessage) in
            guard let self_ = self else { return }
            Utils.hideSpinner()
            
            if self_.pageNo == 1 {
                self_.friendsList.removeAll()
            }
            
            if let list = data?[Keys.list] as? [[String : Any]] {
                
                if list.count > 0 {
                    var users = [Profile]()
                    
                    for object in list {
                        let value = object[Keys.user] as? [String: Any] ?? [:]
                        let user = Profile(data: value)
                        users.append(user)
                        if let first = user.firstName.first {
                            if let value = self_.friendsList[first.description.lowercased()]  as? [Profile] {
                                let filter = value.filter { $0.userId == user.userId }
                                if filter.count == 0 {
                                    var tempUser = [Profile]()
                                    tempUser.append(contentsOf: value)
                                    tempUser.append(user)
                                    self_.friendsList[first.description.lowercased()] = tempUser
                                }
                            } else {
                                self_.friendsList[first.description.lowercased()] = [user]
                            }
                        }
                    }
                    
                    if self_.pageNo == 1 {
                        self_.tempFriendsList = users
                    } else {
                        self_.tempFriendsList.append(contentsOf: users)
                    }
                    self_.pageNo += 1
                    self_.isNextPageExist = true
                } else {
                    self_.isNextPageExist = false
                    if self_.pageNo == 1 {
                        self_.tempFriendsList.removeAll()
                    }
                }
            }
            self_.tableView.reloadData()
        }
    }
}
