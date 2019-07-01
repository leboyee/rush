//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

extension ClubDetailViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        if section == 0 {
            // Navigaiton height + cornerRadius height + changePhotoLabelOrigin
            return ((Utils.navigationHeigh*2) + 24 + 216)
        } else if section == 1 {
            return CGFloat.leastNormalMagnitude
        } else if section == 5 && joinedClub == false {
            return CGFloat.leastNormalMagnitude
        } else {
            return 44
        }
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 1
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 2 ? 88 : (indexPath.section == 5 && joinedClub) ? 48 : (indexPath.section == 1 && joinedClub == false) ? CGFloat.leastNormalMagnitude : UITableView.automaticDimension
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
        cell.setup(title: "Development lifehacks")
        cell.setup(detail: "Get the latest VR Experience with Samsung Gear. You can travel through sdf sdf lkjruto jfdgjlkj dklgj ljdf g", numberOfLines: isReadMore ? 0 : 2)
        cell.setup(readmoreSelected: isReadMore)
        cell.setup(isHideReadmoreButton: false)
        cell.readMoreClickEvent = { [weak self] () in
            guard let self_ = self else { return }
            self_.isReadMore = !self_.isReadMore
            self_.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    func fillJoinedUserCell(_ cell: EventTypeCell) {
        cell.setup(userList: [])
    }
    
    func fillEventByDateCell(_ cell: EventByDateCell) {
        cell.setup(isRemoveDateView: true)
        cell.setup(cornerRadius: 24)
        cell.setup(title: "Marta Keller")
        cell.setup(detail: "3 events")
    }
    
    func fillTagCell(_ cell: TagCell) {
        cell.setup(tagList: ["ABC", "DEF", "TYU", "HDGHJKDHD", "DLHDDDHKD"])
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(isDetailArrowHide: true)
        
        let title = section == 2 ? Text.joined : section == 3 ? Text.organizer : section == 4 ? Text.interestTag : section == 5 ? Text.popularPost : ""
        header.setup(title: title)
        header.setup(isDetailArrowHide: true)
        if section == 5 {
            header.setup(isDetailArrowHide: false)
            header.setup(detailArrowImage: #imageLiteral(resourceName: "brown_down"))
        }
    }
    
    func fillImageHeader(_ view: UserImagesHeaderView) {
        view.setup(image: #imageLiteral(resourceName: "bound-add-img"))
        view.setup(isHideHoverView: true)
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        
    }
}

extension ClubDetailViewController {
    
}
