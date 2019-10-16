//
//  FriendsListLogics.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension FriendsListViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return 50
    }
    
    func fillCell(_ cell: FriendListCell, _ indexPath: IndexPath) {
        
    }

    func fillFriendClubCell(_ cell: FriendClubCell, _ indexPath: IndexPath) {
        cell.setup(detail: "SOMM 24-A")
    }
}

// MARK: - Services
extension FriendsListViewController {
    
    func getEventList() {
        
    }
}

