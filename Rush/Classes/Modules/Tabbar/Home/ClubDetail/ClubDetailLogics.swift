//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos
import SendBirdSDK

extension ClubDetailViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        if section == 3 && clubInfo?.clubUId == Authorization.shared.profile?.userId {
            return CGFloat.leastNormalMagnitude
        } else {
            return section == 0 ? CGFloat.leastNormalMagnitude : (section == 1 || (section == 5 && joinedClub == false)) ? CGFloat.leastNormalMagnitude : section > 5 ? 16 : 44
        }
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 1
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section > 5 {
            if indexPath.row == 2 {
                let images = clubPostList[indexPath.section - 6].images
                if images?.count ?? 0 > 0 {
                    let itemsCount = images?.count ?? 0
                    var count = itemsCount % 2 == 0 ? itemsCount : itemsCount - 1
                    if itemsCount == 1 {
                        count = 1
                    } else if itemsCount >= 6 {
                        count = 6
                    }
                    var height = screenWidth
                    if count > 1 {
                        height = (CGFloat(count) / 2.0) * (screenWidth / 2.0)
                    }
                    return height
                } else {
                    return CGFloat.leastNormalMagnitude
                }
            } else {
                return UITableView.automaticDimension
            }
        } else {
            if indexPath.section == 3 && clubInfo?.clubUId == Authorization.shared.profile?.userId {
                return CGFloat.leastNormalMagnitude
            } else {
                let auto = UITableView.automaticDimension
                return indexPath.section == 2 ? 88 : (indexPath.section == 5 && joinedClub) ? 48 : (indexPath.section == 1 && joinedClub == false) ? CGFloat.leastNormalMagnitude : auto
            }
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
            cell.setup(secondButtonType: .groupChat)
        } else {
            cell.setup(firstButtonType: .joined)
            cell.setup(secondButtonType: .groupChatClub)
        }
        
        if (clubInfo?.clubIsChatGroup ?? 0) == 0 {
            cell.secondButton.isHidden = true
            cell.trailingConstraintOfSecondButton.constant = -(screenWidth - 48 - 7)
        } else {
            cell.secondButton.isHidden = false
            cell.trailingConstraintOfSecondButton.constant = 24
        }
        
        cell.firstButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            
            // Manage
            if unself.clubInfo?.clubUId == Authorization.shared.profile?.userId {
                if let controller = unself.storyboard?.instantiateViewController(withIdentifier: ViewControllerId.createClubViewController) as? CreateClubViewController {
                    controller.clubInfo = unself.clubInfo
                    controller.delegate = self
                    controller.modalPresentationStyle = .overFullScreen
                    let nav = UINavigationController(rootViewController: controller)
                    nav.modalPresentationStyle = .overFullScreen
                    unself.navigationController?.present(nav, animated: false, completion: nil)
                }
            } else { // Joined
                Utils.alert(title: "Are you sure you want to leave this club?", buttons: ["Yes", "No"], handler: { (index) in
                    if index == 0 {
                        unself.joinedClub = false
                        unself.joinClubAPI()
                        unself.tableView.reloadData()
                        // leave club api
                    }
                })
            }
        }
        
        cell.secondButtonClickEvent = { [weak self] () in
            guard let unsafe = self else { return }
            unsafe.checkIsChatExistOrNot()
        }
    }
    
    func checkIsChatExistOrNot() {
        Utils.showSpinner()
        ChatManager().getListOfFilterGroups(name: clubInfo?.clubName ?? "", type: "club", userId: "", { [weak self] (data) in
            guard let unsafe = self else { return }
            Utils.hideSpinner()
            let controller = ChatRoomViewController()
            controller.isGroupChat = true
            controller.chatDetailType = .club
            controller.clubInfo = unsafe.clubInfo
            controller.userName = unsafe.clubInfo?.clubName ?? ""
            controller.hidesBottomBarWhenPushed = true
            
            if let channels = data as? [SBDGroupChannel], channels.count > 0 {
                let filterChannel = channels.filter({ $0.data == unsafe.clubInfo?.clubId })
                controller.channel = filterChannel.first
            }
            unsafe.navigationController?.pushViewController(controller, animated: true)
            }, errorHandler: { (error) in
                print(error?.localizedDescription ?? "")
        })
    }
    
    func fillJoinedUserCell(_ cell: EventTypeCell) {
        cell.setup(invitees: clubInfo?.invitees, total: clubInfo?.clubTotalJoined ?? 0)
        
        cell.userSelected = { [weak self] (id, index) in
            guard let unself = self else { return }
            if index != 0 {
                let invitee = unself.clubInfo?.invitees?[index - 1] // -1 of ViewAll Cell item
                if invitee?.user?.userId == Authorization.shared.profile?.userId {
                    self?.tabBarController?.selectedIndex = 3
                } else {
                    unself.performSegue(withIdentifier: Segues.otherUserProfile, sender: invitee?.user)
                }
            } else {
                //View All clicked
                unself.performSegue(withIdentifier: Segues.friendList, sender: UserProfileDetailType.clubJoinedUsers)
            }
        }
    }
    
    func fillEventByDateCell(_ cell: EventByDateCell, _ indexPath: IndexPath) {
        cell.setup(isRemoveDateView: true)
        cell.setup(cornerRadius: 24)
        cell.setup(isHideSeparator: true)
        cell.clipsToBounds = true
        
        let user = clubInfo?.user
        if let count = clubInfo?.user?.totalEvents, count > 0 {
            let text = count == 1 ? "event" : "events"
            cell.setup(detail: "\(count) \(text)")
        } else {
            cell.setup(detail: "No events")
        }
        cell.setup(title: user?.name ?? "")
        cell.setup(bottomConstraintOfImage: 18.5)
        cell.setup(bottomConstraintOfDate: 22)
        cell.setup(dotButtonConstraint: -24)
        cell.setup(eventImageUrl: clubInfo?.user?.photo?.url())
    }
    
    func fillPostUserCell(_ cell: PostUserCell, _ indexPath: IndexPath) {
        let post = clubPostList[indexPath.section - 6]
        cell.set(name: post.user?.name ?? "")
        cell.set(url: post.user?.photo?.urlThumb())
        cell.moreEvent = { [weak self] () in
            guard let unsafe = self else { return }
            unsafe.performSegue(withIdentifier: Segues.sharePostSegue, sender: post)
        }
        
      /*  if post.user?.userId == Authorization.shared.profile?.userId {
            cell.moreButton.isHidden = false
        } else {
            cell.moreButton.isHidden = true
        } */
        
        if let date = post.createdAt {
            let time = date.timeAgoDisplay()
            cell.set(timeStr: time)
        }
    }
    
    func fillTagCell(_ cell: TagCell) {
        if let tags = clubInfo?.clubInterests {
            let tag = tags.compactMap({ $0.interestName })
            cell.setup(tagList: tag)
        }
    }
    
    func fillSingleButtonCell(_ cell: SingleButtonCell) {
        cell.joinButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            unself.joinedClub = true
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
    
    func fillImageCell(_ cell: UserPostImageTableViewCell, _ indexPath: IndexPath) {
        let post = clubPostList[indexPath.section - 6]
        if let list = post.images {
            cell.set(url: list.first?.url())
        }
        cell.setup(isCleareButtonHide: true)
    }
    
    func fillPostImageCell(_ cell: PostImagesCell, _ indexPath: IndexPath) {
        let post = clubPostList[indexPath.section - 6]
        cell.set(images: post.images)
        cell.showImages = { [weak self] (index) in
            guard let unsafe = self else { return }
            unsafe.showPostImages(post: post, index: index)
        }
    }
    
    func fillPostBottomCell(_ cell: PostBottomCell, _ indexPath: IndexPath) {
        let post = clubPostList[indexPath.section - 6]
        cell.set(numberOfLike: post.totalUpVote)
        cell.set(numberOfComment: post.numberOfComments)
        if let myVote = post.myVote?.first {
            cell.set(vote: myVote.type)
        } else {
            cell.set(vote: 0)
        }
        
        cell.likeButtonEvent = { [weak self] () in
            self?.voteClubAPI(id: post.postId, type: Vote.up)
        }
        
        cell.unlikeButtonEvent = { [weak self] () in
            self?.voteClubAPI(id: post.postId, type: Vote.down)
        }
        
        cell.commentButtonEvent = { [weak self] () in
            self?.performSegue(withIdentifier: Segues.postSegue, sender: post)
        }
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(isDetailArrowHide: true)
        
        let title = section == 2 ? Text.joined : section == 3 ? Text.organizer : section == 4 ? Text.interestTag : section == 5 ? (clubInfo?.clubUId == Authorization.shared.profile?.userId ? Text.posts : Text.posts) : ""
        header.setup(title: title)
        header.setup(isDetailArrowHide: true)
        /*
         if section == 5 {
         header.setup(isDetailArrowHide: false)
         header.setup(detailArrowImage: #imageLiteral(resourceName: "brown_down"))
         }
         */
    }
    
    func fillImageHeader() {
        let img = Image(json: clubInfo?.clubPhoto ?? "")
        clubHeader.setup(clubUrl: img.url())
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
        
        if indexPath.section == 3 { // Club organizer detail
            performSegue(withIdentifier: Segues.otherUserProfile, sender: clubInfo?.user)
        } else if indexPath.section == 5 && joinedClub { // Create post
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
    
    func deletePostAPI(id: String) {
        Utils.showSpinner()
        ServiceManager.shared.deletePost(postId: id, params: [:]) { [weak self] (status, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if status {
                if let index = unsafe.clubPostList.firstIndex(where: { $0.postId == id }) {
                    unsafe.clubPostList.remove(at: index)
                    unsafe.tableView.reloadData()
                }
            } else {
                Utils.alert(message: errorMsg.debugDescription)
            }
        }
    }
    
    func getClubDetailAPI() {
        
        let id = String(clubInfo?.id ?? 0)
        
        Utils.showSpinner()
        ServiceManager.shared.fetchClubDetail(clubId: id, params: [Keys.clubId: id]) { [weak self] (data, errorMsg) in
            guard let uwself = self else { return }
            if let list = data {
                if let club = list[Keys.club] as? [String: Any] {
                    do {
                        let dataClub = try JSONSerialization.data(withJSONObject: club, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        let value = try decoder.decode(Club.self, from: dataClub)
                        uwself.clubInfo = value
                    } catch {
                        
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
        ServiceManager.shared.joinClub(clubId: id, params: [Keys.clubId: id, Keys.action: joinedClub == true ? "join" : "left"]) { [weak self] (status, errorMsg) in
            guard let uwself = self else { return }
            if status {
                if uwself.joinedClub == true {
                    uwself.getClubDetailAPI()
                    ChatManager().addNewMember(type: "club", data: id, userId: Authorization.shared.profile?.userId ?? "")
                } else {
                     uwself.getClubDetailAPI()
                    
//                    Utils.hideSpinner()
//                    uwself.tableView.reloadData()
                }
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
            guard let unsafe = self else { return }
            
            if let post = result {
                let index = unsafe.clubPostList.firstIndex(where: { ( $0.postId == post.postId ) })
                if let position = index, unsafe.clubPostList.count > position {
                    unsafe.clubPostList[position] = post
                    unsafe.tableView.reloadData()
                }
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func deleteClubAPI() {
        
        let id = clubInfo?.id ?? 0
        Utils.showSpinner()
        ServiceManager.shared.deleteClub(clubId: id, params: [Keys.clubId: id]) { [weak self] (status, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if status {
                unsafe.delegate?.deleteClubSuccess(unsafe.clubInfo)
                DispatchQueue.main.async {
                    unsafe.navigationController?.popViewController(animated: true)
                }
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
