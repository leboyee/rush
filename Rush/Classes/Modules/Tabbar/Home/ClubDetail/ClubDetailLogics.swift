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
        return section == 0 ? CGFloat.leastNormalMagnitude : (section == 1 || (section == 5 && joinedClub == false)) ? CGFloat.leastNormalMagnitude : section > 5 ? 16 : 44
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 1
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section > 5 {
            let photos = clubPostList[indexPath.section - 6].images
            if indexPath.row == 2 {
                return (photos == nil || photos?.count == 0) ? CGFloat.leastNormalMagnitude : screenWidth
            }
            return UITableView.automaticDimension
        } else {
            let auto = UITableView.automaticDimension
            return indexPath.section == 2 ? 88 : (indexPath.section == 5 && joinedClub) ? 48 : (indexPath.section == 1 && joinedClub == false) ? CGFloat.leastNormalMagnitude : auto
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
            cell.setup(title: club.clubName ?? "")
            cell.setup(detail: club.clubDesc ?? "", numberOfLines: isReadMore ? 0 : 2)
            cell.setup(readmoreSelected: isReadMore)
            cell.readMoreClickEvent = { [weak self] () in
                guard let uwself = self else { return }
                uwself.isReadMore = !uwself.isReadMore
                uwself.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
    }
    
    func fillClubManageCell(_ cell: ClubManageCell) {
        if clubInfo?.clubUId == Authorization.shared.profile?.userId {
            cell.setup(firstButtonType: .manage)
        } else {
            cell.setup(firstButtonType: .joined)
        }
        
        cell.setup(secondButtonType: .groupChatClub)
        
        cell.firstButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            
            // Manage
            if unself.clubInfo?.clubUId == Authorization.shared.profile?.userId {
                if let controller = unself.storyboard?.instantiateViewController(withIdentifier: ViewControllerId.createClubViewController) as? CreateClubViewController {
                    controller.clubInfo = unself.clubInfo
                    let nav = UINavigationController(rootViewController: controller)
                    unself.navigationController?.present(nav, animated: false, completion: nil)
                }
            } else { // Joined
                Utils.alert(title: "Are you sure you want to leave this club?", buttons: ["Yes", "No"], handler: { (index) in
                    if index == 0 {
                        unself.joinedClub = false
                        unself.tableView.reloadData()
                        
                        // leave club api
                    }
                })
            }
        }
        
        cell.secondButtonClickEvent = { () in
            Utils.notReadyAlert()
        }
    }
    
    func fillJoinedUserCell(_ cell: EventTypeCell) {
        cell.setup(invitees: clubInfo?.invitees, total: 0)
        
        cell.userSelected = { [weak self] (id, index) in
            guard let unself = self else { return }
            if index != 0 {
                let invitee = unself.clubInfo?.invitees?[index - 1] // -1 of ViewAll Cell item
                if invitee?.user?.userId == Authorization.shared.profile?.userId {
                    self?.tabBarController?.selectedIndex = 3
                } else {
                    unself.performSegue(withIdentifier: Segues.otherUserProfile, sender: invitee?.user)
                }
            }
        }
    }
    
    func fillEventByDateCell(_ cell: EventByDateCell, _ indexPath: IndexPath) {
        cell.setup(isRemoveDateView: true)
        cell.setup(cornerRadius: 24)
        cell.setup(isHideSeparator: true)
        if indexPath.section > 5 {
            let post = clubPostList[indexPath.section - 6]
            cell.setup(title: post.user?.name ?? "")
            cell.setup(bottomConstraintOfImage: 0)
            cell.setup(bottomConstraintOfDate: 4)
            cell.setup(dotButtonConstraint: 24)
            
            if let date = Date.parse(dateString: post.createdAt ?? "", format: "yyyy-MM-dd HH:mm:ss") {
                let time = Date().timeAgoDisplay(date: date)
                cell.setup(detail: time)
            }
        } else {
            let user = clubInfo?.user
            cell.setup(detail: "3 events")
            cell.setup(title: user?.name ?? "")
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
            guard let unself = self else { return }
            //unself.joinedClub = true
            //unself.tableView.reloadData()
            unself.joinClubAPI()
        }
    }
    
    // Textview cell (section 6 row 1)
    func fillTextViewCell(_ cell: UserPostTextTableViewCell, _ indexPath: IndexPath) {
        let post = clubPostList[indexPath.section - 6]
        cell.setup(text: post.text ?? "", placeholder: "")
        cell.setup(font: UIFont.regular(sz: 17))
        cell.setup(isUserInterectionEnable: false)
    }
    
    // Image cell (section 6 row 2)
    func fillImageCell(_ cell: UserPostImageTableViewCell, _ indexPath: IndexPath) {
        let post = clubPostList[indexPath.section - 6]
        if let list = post.images {
            cell.set(url: list.first?.url())
        }
        cell.setup(isCleareButtonHide: true)
    }
    
    func fillLikeCell(_ cell: PostLikeCell, _ indexPath: IndexPath) {
        let post = clubPostList[indexPath.section - 6]
        cell.set(numberOfLike: post.numberOfLikes)
        cell.set(numberOfUnLike: post.numberOfUnLikes)
        cell.set(numberOfComment: post.numberOfComments)
        cell.set(ishideUnlikeLabel: false)
        
        cell.likeButtonEvent = { [weak self] () in
            guard let uwself = self else { return }
            uwself.voteClubAPI(id: post.id ?? "", type: "up")
        }
        
        cell.unlikeButtonEvent = { [weak self] () in
            guard let uwself = self else { return }
            uwself.voteClubAPI(id: post.id ?? "", type: "down")
            
        }
        
        cell.commentButtonEvent = { [weak self] () in
            guard let uwself = self else { return }
            uwself.performSegue(withIdentifier: Segues.postSegue, sender: post)
        }
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
    
    func fillImageHeader() {
        let img = Image(json: clubInfo?.clubPhoto ?? "")
        clubHeader.set(url: img.url())
    }
    
    func fillData() {
        if let invitee = clubInfo?.invitees {
            let filter = invitee.filter({ $0.user?.userId == Authorization.shared.profile?.userId })
            if filter.count > 0 {
                joinedClub = true
            }
        }
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        
        if indexPath.section == 5 && joinedClub {
            performSegue(withIdentifier: Segues.createPost, sender: nil)
        } else if indexPath.section > 5 {
            if indexPath.row == 0 {
                let post = clubPostList[indexPath.section - 6]
                if post.user?.userId == Authorization.shared.profile?.userId {
                    self.tabBarController?.selectedIndex = 3
                } else {
                    performSegue(withIdentifier: Segues.otherUserProfile, sender: post.user)
                }
            }
        }
    }
}

// MARK: - Services
extension ClubDetailViewController {
    
    func getClubDetailAPI() {
        
        let id = clubInfo?.clubId ?? ""
        
        Utils.showSpinner()
        ServiceManager.shared.fetchClubDetail(clubId: id, params: [Keys.clubId: id]) { [weak self] (data, errorMsg) in
            guard let uwself = self else { return }
            if let list = data {
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
                uwself.fillImageHeader()
                uwself.fillData()
                uwself.getClubPostListAPI()
                uwself.tableView.reloadData()
            } else {
                Utils.hideSpinner()
                Utils.alert(message: errorMsg.debugDescription)
            }
        }
    }
    
    func joinClubAPI() {
        
        let id = clubInfo?.clubId ?? "0"
        
        Utils.showSpinner()
        ServiceManager.shared.joinClub(clubId: id, params: [Keys.clubId: id]) { [weak self] (status, errorMsg) in
            guard let uwself = self else { return }
            if status {
                uwself.getClubDetailAPI()
            } else {
                Utils.hideSpinner()
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func getClubPostListAPI() {
        
        let param = [Keys.dataId: clubInfo?.clubId ?? "",
                     Keys.dataType: Text.club,
                     Keys.search: "",
                     Keys.pageNo: 1] as [String: Any]
        
        ServiceManager.shared.getPostList(dataId: clubInfo?.clubId ?? "", type: Text.club, params: param) { [weak self] (post, errorMsg) in
            Utils.hideSpinner()
            guard let uwself = self else { return }
            if let value = post {
                uwself.clubPostList = value
                uwself.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func voteClubAPI(id: String, type: String) {
        ServiceManager.shared.votePost(postId: id, voteType: type) { [weak self] (result, errorMsg) in
            Utils.hideSpinner()
            guard let uwself = self else { return }
            if let post = result {
                    let index = uwself.clubPostList.firstIndex(where: { ( $0.id == post.id ) })
                    if let position = index, uwself.clubPostList.count > position {
                        uwself.clubPostList[position] = post
                        
                        let oldOffset = uwself.tableView.contentOffset
                        UIView.setAnimationsEnabled(false)
                        uwself.tableView.beginUpdates()
                        uwself.tableView.reloadRows(at: [IndexPath(row: position, section: 6)], with: .automatic)
                        uwself.tableView.endUpdates()
                        uwself.tableView.setContentOffset(oldOffset, animated: false)
                    }
                uwself.getClubPostListAPI()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
