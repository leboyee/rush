//
//  FriendsListLogics.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension UniversityViewController {
    
    func cellCount(_ section: Int) -> Int {
        return 50
    }
    
    func fillPeopleCell(_ cell: PeopleCell, _ indexPath: IndexPath) {
        cell.setup(title: "Harvard University")
        cell.setup(isCheckMark: selectedIndex == indexPath.row)
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
}
