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
        cell.setup(name: friend.user?.name ?? "")
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

        //NetworkManager.shared.lastSessionTask?.cancel()
        task?.cancel()
        if pageNo == 1 { friendsList.removeAll() }
        let params = [Keys.pageNo: "\(pageNo)", Keys.search: searchText, Keys.profileUserId: userId] as [String: Any]
        task = ServiceManager.shared.fetchFriendsListWithSession(params: params) { [weak self] (data, _) in
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
                if unsafe.isFirstTime == false {
                    unsafe.isFirstTime = true
                    unsafe.searchTextFiled?.isUserInteractionEnabled = unsafe.friendsList.count > 0 ? true : false
                } else {
                    unsafe.searchTextFiled?.isUserInteractionEnabled = true
                }
                unsafe.noSearchResultView.isHidden = unsafe.friendsList.count == 0 ? false : true
                unsafe.tableView.reloadData()
            }
        }
    }
}
