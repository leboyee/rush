//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

extension MyClubViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return (section == 0 || section == 1) ? CGFloat(CFloat.leastNormalMagnitude) : 44
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 1
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 2 ? 88 : UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        if section == 2 {
            return interestList.count + 1
        } else if section == 3 {
            return peopleList.count + 1
        }
        return 1
    }
    
    func fillClubNameCell(_ cell: ClubNameCell) {
        
    }
    
    func fillJoinedUserCell(_ cell: EventTypeCell) {
        cell.setup(userList: [])
    }
    
    func fillTagCell(_ cell: TagCell) {
        cell.setup(tagList: ["ABC", "DEF", "TYU", "HDGHJKDHD", "DLHDDDHKD"])
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(isDetailArrowHide: true)
        if section == 2 {
            header.setup(title: Text.joined)
        } else if section == 3 {
            header.setup(title: Text.interestTag)
        } else if section == 4 {
            header.setup(title: Text.posts)
        }
    }
}

extension MyClubViewController {
    
}
