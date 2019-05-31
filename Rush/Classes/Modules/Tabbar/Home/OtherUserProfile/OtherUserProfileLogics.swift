//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

extension OtherUserProfileController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return section == 0 ? CGFloat(CFloat.leastNormalMagnitude) : 44
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return (section == 0 || section == 1 || section == 2) ? 1 : 0
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableView.automaticDimension : indexPath.section == 1 ? 112 : indexPath.section == 2 ? 88 : 157
    }
    
    func cellCount(_ section: Int) -> Int {
        return 1
    }
    
    func fillEventCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            cell.setup(imagesList: [])
        case 2:
            cell.setup(userList: [])
        case 3:
            cell.setup(.upcoming, nil)
        case 4:
            cell.setup(.clubs, nil)
        case 5:
            cell.setup(.classes, nil)
        default:
            break
        }
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        
        let text = section == 0 ? "" : section == 1 ? Text.images : section == 2 ? Text.friends : section == 3 ? Text.events : section == 4 ? Text.clubs : section == 5 ? Text.classes : ""
        header.setup(title: text)
        
    }
}

extension OtherUserProfileController {
    
}
