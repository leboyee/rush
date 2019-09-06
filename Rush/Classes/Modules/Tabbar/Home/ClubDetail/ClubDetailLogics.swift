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
        return section == 0 ? ((Utils.navigationHeigh*2) + 24 + 216) : (section == 1 || (section == 5 && joinedClub == false)) ? CGFloat.leastNormalMagnitude : section > 5 ? 16 : 44
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 1
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section > 5 {
            return indexPath.row == 2 ? (indexPath.section == 6 ? CGFloat.leastNormalMagnitude :  screenWidth) : UITableView.automaticDimension
        } else {
            return indexPath.section == 2 ? 88 : (indexPath.section == 5 && joinedClub) ? 48 : (indexPath.section == 1 && joinedClub == false) ? CGFloat.leastNormalMagnitude : UITableView.automaticDimension
        }
    }
    
    func cellCount(_ section: Int) -> Int {
        if section == 2 {
            return interestList.count + 1
        } else if section == 3 {
            return peopleList.count + 1
        } else if section > 5 {
            return 4
        }
        return 1
    }
    
    // Section 0
    func fillClubNameCell(_ cell: ClubNameCell) {
        if let club = clubInfo {
            cell.setup(title: club.clubName)
            cell.setup(detail: club.clubDesc, numberOfLines: isReadMore ? 0 : 2)
            cell.setup(readmoreSelected: isReadMore)
            cell.readMoreClickEvent = { [weak self] () in
                guard let self_ = self else { return }
                self_.isReadMore = !self_.isReadMore
                self_.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
    }
    
    func fillClubManageCell(_ cell: ClubManageCell) {
        cell.setup(firstButtonType: .joined)
        cell.setup(secondButtonType: .groupChatClub)
        
        cell.firstButtonClickEvent = { [weak self] () in
            guard let self_ = self else { return }
            Utils.alert(title: "Are you sure you want to leave from this club?",buttons: ["Yes", "No"],handler: { (index) in
                if index == 0 {
                    self_.joinedClub = false
                    self_.tableView.reloadData()
                }
            })
        }
        
        cell.secondButtonClickEvent = { [weak self] () in
            guard let _ = self else { return }
            Utils.notReadyAlert()
        }
    }
    
    func fillJoinedUserCell(_ cell: EventTypeCell) {
        cell.setup(userList: clubInfo?.invitees)
        
        cell.userSelected = { [weak self] (id, index) in
            guard let self_ = self else { return }
            if index != 0 {
                self_.performSegue(withIdentifier: Segues.otherUserProfile, sender: nil)
            }
        }
    }
    
    func fillEventByDateCell(_ cell: EventByDateCell,_ indexPath: IndexPath) {
        let user = clubInfo?.user
        cell.setup(isRemoveDateView: true)
        cell.setup(cornerRadius: 24)
        cell.setup(title: (user?.firstName ?? "") + " " + (user?.lastName ?? ""))
        cell.setup(detail: "3 events")
        cell.setup(isHideSeparator: true)
        if indexPath.section > 5 {
            cell.setup(bottomConstraintOfImage: 0)
            cell.setup(bottomConstraintOfDate: 4)
            cell.setup(dotButtonConstraint: 24)
        } else {
            cell.setup(bottomConstraintOfImage: 18.5)
            cell.setup(bottomConstraintOfDate: 22)
            cell.setup(dotButtonConstraint: -24)
        }
    }
    
    func fillTagCell(_ cell: TagCell) {
        let tags = (clubInfo?.clubInterests ?? "").components(separatedBy: ",")
        cell.setup(tagList: tags)
    }
    
    func fillSingleButtonCell(_ cell: SingleButtonCell) {
        cell.joinButtonClickEvent = { [weak self] () in
            guard let self_ = self else { return }
            self_.joinedClub = true
            self_.tableView.reloadData()
        }
    }
    
    // Textview cell (section 6 row 1)
    func fillTextViewCell(_ cell: UserPostTextTableViewCell) {
        cell.setup(text: "It’s so great to see you guys! I hope we’ll have a great day :)", placeholder: "")
        cell.setup(font: UIFont.Regular(sz: 17))
        cell.setup(isUserInterectionEnable: false)
    }
    
    // Image cell (section 6 row 2)
    func fillImageCell(_ cell: UserPostImageTableViewCell, _ indexPath: IndexPath) {
        cell.postImageView?.image = #imageLiteral(resourceName: "bound-add-img")
        cell.setup(isCleareButtonHide: true)
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
        let img = Image(json: clubInfo?.clubPhoto ?? "")
        view.setup(imageUrl: img.url)
        view.setup(isHideHoverView: true)
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        
        if indexPath.section == 5 && joinedClub {
            performSegue(withIdentifier: Segues.createPost, sender: nil)
        }
    }
}

// MARK: - Services
extension ClubDetailViewController {
    
    func getClubDetailAPI() {
        
        let id = clubInfo?.id ?? ""
        
        Utils.showSpinner()
        NetworkManager.shared.getClubDetail(clubId: id, params: [Keys.clubId: id]) { [weak self] (data, errorMsg, status) -> (Void) in
            Utils.hideSpinner()
            guard let uwself = self else { return }
            if let list = data as? [String: Any] {
                if let value = list[Keys.data] as? [String: Any] {
                    if let club = value[Keys.club] as? [String: Any] {
                        do {
                            let dataClub = try JSONSerialization.data(withJSONObject: club, options: .prettyPrinted)
                            let decoder = JSONDecoder()
                            let value = try decoder.decode(Club.self, from: dataClub)
                            uwself.clubInfo = value
                        } catch {
                            
                        }
                    }
                }
                uwself.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg.debugDescription)
            }
        }
    }
}
