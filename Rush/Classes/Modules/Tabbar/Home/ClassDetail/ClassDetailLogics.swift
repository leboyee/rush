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
    
    /*
    if indexPath.section > 5 {
    let photos = clubPostList[indexPath.section - 6].images
    if indexPath.row == 2 {
    return (photos == nil || photos?.count == 0) ? CGFloat.leastNormalMagnitude : screenWidth
    }
    return UITableView.automaticDimension
    } else {
    if indexPath.section == 3 && clubInfo?.clubUId == Authorization.shared.profile?.userId {
    return CGFloat.leastNormalMagnitude
    } else {
    let auto = UITableView.automaticDimension
    return indexPath.section == 2 ? 88 : (indexPath.section == 5 && joinedClub) ? 48 : (indexPath.section == 1 && joinedClub == false) ? CGFloat.leastNormalMagnitude : auto
    }
    }
    */
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && joinedClub == false {
            return CGFloat.leastNormalMagnitude
        } else if indexPath.section > 5 {
            let photos = classesPostList[indexPath.section - 6].images
            if indexPath.row == 2 {
                return (photos == nil || photos?.count == 0) ? CGFloat.leastNormalMagnitude : screenWidth
            }
            return UITableView.automaticDimension
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
        
        cell.setup(title: subclassInfo?.name ?? "Development lifehacks")
        cell.setup(detail: selectedGroup?.name ?? "FINA 40", numberOfLines: 0)
        cell.setup(isHideReadmoreButton: true)
        cell.setup(detailTextColor: UIColor.buttonDisableTextColor)
    }
    
    func fillClubManageCell(_ cell: ClubManageCell) {
        cell.setup(firstButtonType: .joined)
        cell.setup(secondButtonType: .groupChatClub)
        
/*      cell.firstButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            Utils.alert(title: "Are you sure you want to leave this class?", buttons: ["Yes", "No"], handler: { (index) in
                if index == 0 {
                    unself.joinedClub = false
                    unself.tableView.reloadData()
                }
            })
        }*/
        
        cell.secondButtonClickEvent = { () in
            Utils.notReadyAlert()
        }
    }
    
    func fillTimeCell(_ cell: TextIconCell, _ indexPath: IndexPath) {
        cell.resetAllField()
        cell.setup(isUserInterfaceEnable: false)
        if indexPath.section == 3 {
            cell.setup(placeholder: "", title: subclassInfo?.location ?? "Harvard main campus")
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
        cell.setup(invitees: [], total: 0)
    }
    
    func fillEventByDateCell(_ cell: EventByDateCell, _ indexPath: IndexPath) {
        cell.setup(isRemoveDateView: true)
        cell.setup(cornerRadius: 24)
        if indexPath.section > 5 {
            let post = classesPostList[indexPath.section - 6]
            cell.setup(title: post.user?.name ?? "")
            cell.setup(eventImageUrl: post.user?.photo?.url())
            cell.setup(bottomConstraintOfImage: 0)
            cell.setup(bottomConstraintOfDate: 4)
            cell.setup(dotButtonConstraint: 24)
            if post.user?.userId == Authorization.shared.profile?.userId {
                cell.threeDots.isHidden = false
            } else {
                cell.threeDots.isHidden = true
            }
            cell.shareClickEvent = { [weak self] () in
                guard self != nil else { return }
                self?.performSegue(withIdentifier: Segues.sharePostSegue, sender: post)
            }
            if let date = Date.parse(dateString: post.createdAt ?? "", format: "yyyy-MM-dd HH:mm:ss") {
                let time = Date().timeAgoDisplay(date: date)
                cell.setup(detail: time)
            }
        }
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
            unself.joinClassAPI()
        }
    }
    func checkIsJoined() {
        if subclassInfo?.myJoinedClass?.count ?? 0 > 0 {
            joinedClub = true
        } else {
            joinedClub = false
        }
    }
    // Textview cell (section 6 row 1)
    func fillTextViewCell(_ cell: UserPostTextTableViewCell, _ indexPath: IndexPath) {
        if indexPath.section > 5 {
            let post = classesPostList[indexPath.section - 6]
            cell.setup(text: post.text ?? "", placeholder: "")
        }
        cell.setup(font: UIFont.regular(sz: 17))
        cell.setup(isUserInterectionEnable: false)
    }
    
    // Image cell (section 6 row 2)
    func fillImageCell(_ cell: UserPostImageTableViewCell, _ indexPath: IndexPath) {
        if indexPath.section > 5 {
            let post = classesPostList[indexPath.section - 6]
            if let list = post.images {
                cell.set(url: list.first?.url())
            }
        }
        cell.setup(isCleareButtonHide: true)
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(isDetailArrowHide: true)
        
        let title = section == 2 ? Text.rosters : section == 3 ? Text.organizer : section == 4 ? Text.rosters : section == 5 ? Text.posts : ""
        header.setup(title: title)
        header.setup(isDetailArrowHide: true)
        /*
        if section == 5 {
            header.setup(isDetailArrowHide: false)
            header.setup(detailArrowImage: #imageLiteral(resourceName: "brown_down"))
        }
        */
    }
    
    func fillImageHeader(_ view: UserImagesHeaderView) {
        let img = Image(json: subclassInfo?.photo ?? "")
        view.setup(imageUrl: img.url())
        view.setup(isHideHoverView: false)
        view.setup(isHidePhotoButton: true)
    }
   
    func fillLikeCell(_ cell: PostLikeCell, _ indexPath: IndexPath) {
        let post = classesPostList[indexPath.section - 6]
        cell.set(numberOfLike: post.numberOfLikes)
        cell.set(numberOfUnLike: post.numberOfUnLikes)
        cell.set(numberOfComment: post.numberOfComments)
        cell.set(ishideUnlikeLabel: false)
        
        if let myVote = post.myVote?.first {
            cell.set(vote: myVote.type)
        } else {
            cell.set(vote: 0)
        }
        
        cell.likeButtonEvent = { [weak self] () in
            guard let uwself = self else { return }
            uwself.voteClubAPI(id: post.postId, type: "up")
        }
        
        cell.unlikeButtonEvent = { [weak self] () in
            guard let uwself = self else { return }
            uwself.voteClubAPI(id: post.postId, type: "down")
        }
        
        cell.commentButtonEvent = { [weak self] () in
            guard let uwself = self else { return }
            uwself.performSegue(withIdentifier: Segues.postSegue, sender: post)
        }
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            isShowMore = !isShowMore
            tableView.reloadData()
        } else if indexPath.section == 3 {
            Utils.notReadyAlert()
        } else if indexPath.section == 5 {
            if joinedClub {
                showCreatePost()
            }
        }
    }
    func showCreatePost() {
        performSegue(withIdentifier: Segues.createPost, sender: nil)
    }
    
}

extension ClassDetailViewController {
    func deletePostAPI(id: String) {
             Utils.showSpinner()
             ServiceManager.shared.deletePost(postId: id, params: [:]) { [weak self] (status, errorMsg) in
                  Utils.hideSpinner()
                  guard let unsafe = self else { return }
                  if status {
                   if let index = unsafe.classesPostList.firstIndex(where: { $0.postId == id }) {
                       unsafe.classesPostList.remove(at: index)
                       unsafe.tableView.reloadData()
                      }
                  } else {
                       Utils.alert(message: errorMsg.debugDescription)
                  }
              }
          }
      
    func joinClassAPI() {
        Utils.showSpinner()
        ServiceManager.shared.joinClassGroup(classId: selectedGroup?.classId ?? "0", groupId: selectedGroup?.id ?? "0", params: [:]) { [weak self] (status, errorMsg) in
            guard let uwself = self else { return }
            if status {
                Utils.hideSpinner()
                uwself.joinedClub = true
                uwself.tableView.reloadData()
            } else {
                Utils.hideSpinner()
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    func getClassDetailAPI(classId: String, groupId: String) {
        Utils.showSpinner()
        
        ServiceManager.shared.getClassDetail(classId: classId, groupId: groupId, params: [:]) { [weak self] (data, errorMsg) in
            guard let uwself = self else { return }
            Utils.hideSpinner()
            if let value = data?[Keys.kclass] as? [String: Any] {
                do {
                    let dataClass = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    let value1 = try decoder.decode(SubClass.self, from: dataClass)
                    uwself.subclassInfo = value1
                    uwself.checkIsJoined()
                    if uwself.subclassInfo?.classGroups?.count ?? 0 > 0 {
                        uwself.selectedGroup = uwself.subclassInfo?.classGroups?[0]
                    }
                    uwself.getClassPostListAPI()
                    uwself.tableView.reloadData()
                } catch {
                    
                }
            } else {
                Utils.hideSpinner()
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func getClassPostListAPI() {
        
        let param = [Keys.dataId: subclassInfo?.id ?? "",
                     Keys.dataType: Text.classKey,
                     Keys.search: "",
                     Keys.pageNo: 1] as [String: Any]
        
        ServiceManager.shared.getPostList(dataId: subclassInfo?.id ?? "", type: Text.classKey, params: param) { [weak self] (post, errorMsg) in
            Utils.hideSpinner()
            guard let uwself = self else { return }
            if let value = post {
                uwself.classesPostList = value
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
                let index = uwself.classesPostList.firstIndex(where: { ( $0.postId == post.postId ) })
                if let position = index, uwself.classesPostList.count > position {
                    uwself.classesPostList[position] = post
                    
                    let oldOffset = uwself.tableView.contentOffset
                    UIView.setAnimationsEnabled(false)
                    uwself.tableView.beginUpdates()
                    uwself.tableView.reloadRows(at: [IndexPath(row: position, section: 6)], with: .automatic)
                    uwself.tableView.endUpdates()
                    uwself.tableView.setContentOffset(oldOffset, animated: false)
                }
                uwself.getClassPostListAPI()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
}
