//
//  UserFriendsListLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension UserFriendsListViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return friendsList.count
    }
    
    func fillCell(_ cell: FriendListCell, _ indexPath: IndexPath) {
        let friend = friendsList[indexPath.row]
        cell.setup(name: friend.friendName)
        if let url = URL(string: friend.user?.photo?.thumb ?? "") {
            cell.setup(url: url)
        }
    }
    
    func selectedCell(_ indexPath: IndexPath) {
        let friend = friendsList[indexPath.row]
        self.performSegue(withIdentifier: Segues.friendProfileSegue, sender: friend.user)
    }
    
    func willDisplay(_ indexPath: IndexPath) {
        if isNextPageExist == true, indexPath.row == friendsList.count - 1 {
            getFriendListAPI()
        }
    }
}

// MARK: - Services
extension UserFriendsListViewController {
    func getFriendListAPI() {
        
        if pageNo == 1 { friendsList.removeAll() }
        var params = [Keys.pageNo: "\(pageNo)"]
        params[Keys.search] = searchTextFiled?.text
        params[Keys.profileUserId] = userId
        
        ServiceManager.shared.fetchFriendsList(params: params) { [weak self] (data, _) in
            guard let unsafe = self else { return }
            Utils.hideSpinner()
            
            if unsafe.pageNo == 1 {
                unsafe.friendsList.removeAll()
            }
            
            if let list = data {
                if list.count > 0 {
                    if unsafe.pageNo == 1 {
                        unsafe.friendsList = list
                    } else {
                        unsafe.friendsList.append(contentsOf: list)
                    }
                    unsafe.pageNo += 1
                    unsafe.isNextPageExist = true
                } else {
                    unsafe.isNextPageExist = false
                    if unsafe.pageNo == 1 {
                        unsafe.friendsList.removeAll()
                    }
                }
                
                unsafe.noSearchResultView.isHidden = unsafe.friendsList.count == 0 ? false : true
                unsafe.tableView.reloadData()
            }
            
        }
    }
}
