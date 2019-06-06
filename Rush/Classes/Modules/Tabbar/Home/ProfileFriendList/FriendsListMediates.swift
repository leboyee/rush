//
//  FriendsListMediates.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 56
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: Cell.friendList, bundle: nil), forCellReuseIdentifier: Cell.friendList)
        tableView.register(UINib(nibName: Cell.eventByDate, bundle: nil), forCellReuseIdentifier: Cell.eventByDate)
        tableView.register(UINib(nibName: Cell.friendClub, bundle: nil), forCellReuseIdentifier: Cell.friendClub)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if type == .friends {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.friendList, for: indexPath) as! FriendListCell
            fillCell(cell, indexPath)
            return cell
        } else if type == .events {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventByDate, for: indexPath) as! EventByDateCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.friendClub, for: indexPath) as! FriendClubCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
    
}
