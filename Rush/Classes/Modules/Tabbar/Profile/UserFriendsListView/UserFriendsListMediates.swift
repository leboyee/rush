//
//  UserFriendsListMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension UserFriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 56
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: Cell.friendList, bundle: nil), forCellReuseIdentifier: Cell.friendList)
        tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.friendList, for: indexPath) as? FriendListCell else { return UITableViewCell() }
        fillCell(cell, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           willDisplay(indexPath)
       }
}

extension UserFriendsListViewController: UITextFieldDelegate {
    @objc func textDidChange(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 0 {
            isSearch = true
            rightBarButton?.image = #imageLiteral(resourceName: "deleteFriendsIcon")
        } else {
            isSearch = false
            rightBarButton?.image = #imageLiteral(resourceName: "plus_white")
        }
        
        searchText = textField.text ?? ""
        pageNo = 1
        getFriendListAPI()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - OtherUserProfile delegate
extension UserFriendsListViewController: OtherUserProfileProtocol {
    func unfriendUser(_ name: String) {
        pageNo = 1
        getFriendListAPI()
    }
}
