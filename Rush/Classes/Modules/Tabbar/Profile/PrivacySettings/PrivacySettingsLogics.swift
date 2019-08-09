//
//  PrivacySettingsLogics.swift
//  Rush
//
//  Created by kamal on 09/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension PrivacySettingsViewController {
   
    func cellCount(_ section: Int) -> Int {
        return list.count
    }
    
    func fillCell(_ cell: CheckMarkCell, _ indexPath: IndexPath) {
       cell.setup(title: list[indexPath.row])
       cell.setup(isCheckMarkShow: selectedIndex == indexPath.row)
    }
    
    func selectedRow(_ indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
}
