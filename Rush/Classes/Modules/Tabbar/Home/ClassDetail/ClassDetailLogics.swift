//
//  HomeLogics.swift
//  Rush
//
//  Created by Chirag on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

extension ClassDetailViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        let photoHeight = (Utils.navigationHeigh*2) + 24 + 216
        let least = CGFloat.leastNormalMagnitude
        return section == 0 ? photoHeight : (section == 1 || (section == 5 && joinedClub == false) || section == 3 || (section == 2 && isShowMore == false)) ? least : section > 5 ? 16 : (section == 2 && isShowMore) ? 16 : 44
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return (isShowMore && section == 2) ? 16 :  1
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && joinedClub == false {
            return CGFloat.leastNormalMagnitude
        } else if indexPath.section > 5 {
            return indexPath.row == 2 ? (indexPath.section == 6 ? CGFloat.leastNormalMagnitude :  screenWidth) : UITableView.automaticDimension
        } else {
            return indexPath.section == 4 ? 88 : (indexPath.section == 5 && joinedClub) ? 48 : UITableView.automaticDimension
        }
    }
    
    func cellCount(_ section: Int) -> Int {
        if section == 2 && isShowMore {
            return timeList.count
        } else if section > 5 {
            return 4
        }
        return 1
    }
    
    // Section 0
    func fillClubNameCell(_ cell: ClubNameCell) {
        cell.setup(title: "Development lifehacks")
        cell.setup(detail: "FINA 140", numberOfLines: 0)
        cell.setup(isHideReadmoreButton: true)
        cell.setup(detailTextColor: UIColor.buttonDisableTextColor)
    }
    
    func fillClubManageCell(_ cell: ClubManageCell) {
        cell.setup(firstButtonType: .joined)
        cell.setup(secondButtonType: .groupChatClub)
        
        cell.firstButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            Utils.alert(title: "Are you sure you want to leave from this class?", buttons: ["Yes", "No"], handler: { (index) in
                if index == 0 {
                    unself.joinedClub = false
                    unself.tableView.reloadData()
                }
            })
        }
        
        cell.secondButtonClickEvent = { () in
            Utils.notReadyAlert()
        }
    }
    
    func fillTimeCell(_ cell: TextIconCell, _ indexPath: IndexPath) {
        cell.resetAllField()
        cell.setup(isUserInterfaceEnable: false)
        if indexPath.section == 3 {
            cell.setup(placeholder: "", title: "Harvard main campus")
            cell.setup(iconImage: "location-gray")
        } else {
            cell.setup(iconImage: "calender-gray")
            cell.setup(placeholder: "", title: "Today ⋅ 4:30 pm - 5:55 pm")
            cell.setup(isSetDropDown: true)
            cell.setup(isHideCleareButton: false)
            
            cell.clearButtonClickEvent = { [weak self] () in
                guard let unself = self else { return }
                // Show all time slot
                unself.isShowMore = true
                unself.tableView.reloadData()
            }
        }
    }
    
    func fillTimeSlotCell(_ cell: TimeSlotCell, _ indexPath: IndexPath) {
        cell.setup(day: timeList[indexPath.row])
        cell.setup(isHideDropDown: indexPath.row == 0 ? false : true)
    }
    
    func fillJoinedUserCell(_ cell: EventTypeCell) {
        cell.setup(userList: [])
    }
    
    func fillEventByDateCell(_ cell: EventByDateCell, _ indexPath: IndexPath) {
        cell.setup(isRemoveDateView: true)
        cell.setup(cornerRadius: 24)
        cell.setup(title: "Marta Keller")
        cell.setup(detail: "3 events")
        cell.setup(isHideSeparator: true)
        if indexPath.section > 5 {
            cell.setup(bottomConstraintOfImage: 0)
            cell.setup(bottomConstraintOfDate: 4)
        } else {
            cell.setup(bottomConstraintOfImage: 18.5)
            cell.setup(bottomConstraintOfDate: 22)
        }
    }
    
    func fillSingleButtonCell(_ cell: SingleButtonCell) {
        cell.setup(title: "Join class")
        cell.joinButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            unself.joinedClub = true
            unself.tableView.reloadData()
        }
    }
    
    // Textview cell (section 6 row 1)
    func fillTextViewCell(_ cell: UserPostTextTableViewCell) {
        
        cell.setup(text: "It’s so great to see you guys! I hope we’ll have a great day :)", placeholder: "")
        cell.setup(font: UIFont.regular(sz: 17))
        cell.setup(isUserInterectionEnable: false)
    }
    
    // Image cell (section 6 row 2)
    func fillImageCell(_ cell: UserPostImageTableViewCell, _ indexPath: IndexPath) {
        cell.postImageView?.image = #imageLiteral(resourceName: "bound-add-img")
        cell.setup(isCleareButtonHide: true)
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(isDetailArrowHide: true)
        
        let title = section == 2 ? Text.rosters : section == 3 ? Text.organizer : section == 4 ? Text.rosters : section == 5 ? Text.popularPost : ""
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
        if indexPath.section == 2 && indexPath.row == 0 {
            isShowMore = !isShowMore
            tableView.reloadData()
        } else if indexPath.section == 3 {
            Utils.notReadyAlert()
        }
    }
}

extension ClassDetailViewController {
    
}
