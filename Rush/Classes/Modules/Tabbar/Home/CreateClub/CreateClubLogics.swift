//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension CreateClubViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : 50
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 8
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return 1
    }
    
    func fillTextIconCell(_ cell: TextIconCell, _ indexPath: IndexPath) {
        
        cell.setup(isHideCleareButton: true)
        cell.setup(iconImage: "")
        cell.setup(isUserInterfaceEnable: false)
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.setup(iconImage: "club-gray-1")
            cell.setup(title: "Name club")
            cell.setup(isUserInterfaceEnable: true)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            cell.setup(iconImage: "interest-gray")
            cell.setup(title: "Add interests")
        } else if indexPath.section == 2 && indexPath.row == 0 {
            cell.setup(iconImage: "friend-gray")
            cell.setup(title: "Invite people")
        }
    }
    
}
