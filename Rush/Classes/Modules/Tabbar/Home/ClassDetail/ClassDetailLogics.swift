//
//  HomeLogics.swift
//  Rush
//
//  Created by Chirag on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos
import SendBirdSDK

extension ClassDetailViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        
        let least = CGFloat.leastNormalMagnitude
        return section == 0 ? least : (section == 1 || (section == 5 && joinedClub == false) || section == 3 || (section == 2 && isShowMore == false)) ? least : section > 5 ? 16 : (section == 2 && isShowMore) ? 16 : 44
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return (isShowMore && section == 2) ? 16 :  1
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && joinedClub == false {
            return CGFloat.leastNormalMagnitude
        } else if indexPath.section > 5 {
            if indexPath.row == 2 {
                let images = classesPostList[indexPath.section - 6].images
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
            return indexPath.section == 4 ? 88 : (indexPath.section == 5 && joinedClub) ? 48 : UITableView.automaticDimension
        }
    }
    
    func cellCount(_ section: Int) -> Int {
        if section == 2 && isShowMore {
            return selectedGroup?.classGroupSchedule?.count ?? 0
        } else if section > 5 {
            return 4
        }
        return 1
    }
    
    // Section 0
    func fillClubNameCell(_ cell: ClubNameCell) {
        cell.setup(title: subclassInfo?.name ?? "")
        cell.setup(detail: selectedGroup?.name ?? "", numberOfLines: 0)
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
        
        cell.secondButtonClickEvent = { [weak self] () in
            guard let unsafe = self else { return }
            unsafe.checkIsChatExistOrNot()
        }
    }
    
    func fillTextViewCell(_ cell: TextViewCell) {
        cell.setup(iconImage: "location-gray")
        cell.setup(placeholder: "", text: subclassInfo?.location ?? "")
        cell.textView.isUserInteractionEnabled = false
        cell.setup(isHideCleareButton: true)
    }
    
    func fillTimeCell(_ cell: TextIconCell, _ indexPath: IndexPath) {
        cell.resetAllField()
        cell.setup(isUserInterfaceEnable: false)
        if indexPath.section == 3 {
            cell.setup(placeholder: "", title: subclassInfo?.location ?? "Harvard main campus")
            cell.setup(iconImage: "location-gray")
        } else {
            cell.setup(iconImage: "calender-gray")
            if selectedGroup?.classGroupSchedule?.count ?? 0 > 0 {
                let classSchedule = selectedGroup?.classGroupSchedule
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                let sdate = dateFormatter.date(from: classSchedule?[0].startTime ?? "12:12:12")
                dateFormatter.dateFormat = "h:mm a"
                let startTime = dateFormatter.string(from: sdate!)
                dateFormatter.dateFormat = "HH:mm:ss"
                let edate = dateFormatter.date(from: classSchedule?[0].endTime ?? "12:12:12")
                dateFormatter.dateFormat = "h:mm a"
                let endTime = dateFormatter.string(from: edate!)
                let day = classSchedule?[0].day.capitalized ?? ""
                let title = startTime + "-" + endTime
                cell.setup(placeholder: "", title: day + " " + title)
            }
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
        let classSchedule = selectedGroup?.classGroupSchedule
        cell.setup(day: classSchedule?[indexPath.row].day.capitalized ?? "")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let sdate = dateFormatter.date(from: classSchedule?[indexPath.row].startTime ?? "12:12:12")!
        dateFormatter.dateFormat = "h:mm a"
        let startTime = dateFormatter.string(from: sdate)
        dateFormatter.dateFormat = "HH:mm:ss"
        let edate = dateFormatter.date(from: classSchedule?[indexPath.row].endTime ?? "12:12:12")
        dateFormatter.dateFormat = "h:mm a"
        let endTime = dateFormatter.string(from: edate!)
        cell.setup(start: startTime, end: endTime)
        cell.setup(isHideDropDown: indexPath.row == 0 ? false : true)
    }
    
    func fillJoinedUserCell(_ cell: EventTypeCell) {
        var rosterArray = [Invitee]()
        for rs in selectedGroup?.classGroupRosters ?? [ClassJoined]() {
            if let user = rs.user {
                let inv = Invitee()
                inv.user = user
                rosterArray.append(inv)
            }
        }
        cell.setup(invitees: rosterArray, total: selectedGroup?.totalRosters ?? 0)
        cell.userSelected = { [weak self] (id, index) in
            guard let unself = self else { return }
            if index != 0 {
                let invitee = rosterArray[index - 1] // -1 of ViewAll Cell item
                if invitee.user?.userId == Authorization.shared.profile?.userId {
                    self?.tabBarController?.selectedIndex = 3
                } else {
                    unself.performSegue(withIdentifier: Segues.otherUserProfile, sender: invitee.user)
                }
            } else {
                //View All clicked
                unself.performSegue(withIdentifier: Segues.friendList, sender: UserProfileDetailType.classRoasters)
            }
            
        }
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
            if let date = post.createdAt {
                let time = date.timeAgoDisplay()
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
    
    func fillPostUserCell(_ cell: PostUserCell, _ indexPath: IndexPath) {
        let post = classesPostList[indexPath.section - 6]
        cell.set(name: post.user?.name ?? "")
        cell.set(url: post.user?.photo?.urlThumb())
        cell.moreEvent = { [weak self] () in
            guard let unsafe = self else { return }
            unsafe.performSegue(withIdentifier: Segues.sharePostSegue, sender: post)
        }
        
        if post.user?.userId == Authorization.shared.profile?.userId {
            cell.moreButton.isHidden = false
        } else {
            cell.moreButton.isHidden = true
        }
        
        if let date = post.createdAt {
            let time = date.timeAgoDisplay()
            cell.set(timeStr: time)
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
    func fillPostImageCell(_ cell: PostImagesCell, _ indexPath: IndexPath) {
        let post = classesPostList[indexPath.section - 6]
        cell.set(images: post.images)
        cell.showImages = { [weak self] (index) in
            guard let unsafe = self else { return }
            unsafe.showPostImages(post: post, index: index)
        }
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
    func fillImageHeader() {
        let img = subclassInfo?.photo
        clubHeader.changePhotoButton.isHidden = true
        clubHeader.addPhotoButton.isHidden = true
        clubHeader.setup(classUrl: img?.url())
        clubHeader.hoverView.isHidden = false
    }
    
    func fillPostBottomCell(_ cell: PostBottomCell, _ indexPath: IndexPath) {
        let post = classesPostList[indexPath.section - 6]
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
    
    func cellSelected(_ indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            isShowMore = !isShowMore
            tableView.reloadData()
        } else if indexPath.section == 3 {
            // Utils.notReadyAlert()
        } else if indexPath.section == 5 {
            if joinedClub {
                showCreatePost()
            }
        }
    }
    func showCreatePost() {
        performSegue(withIdentifier: Segues.createPost, sender: nil)
    }
    
    func checkIsChatExistOrNot() {
        Utils.showSpinner()
        ChatManager().getListOfFilterGroups(name: subclassInfo?.name ?? "", type: "class", userId: "", { [weak self] (data) in
            guard let unsafe = self else { return }
            
            var rosterArray = [Invitee]()
            for rs in unsafe.selectedGroup?.classGroupRosters ?? [ClassJoined]() {
                if let user = rs.user {
                    let inv = Invitee()
                    inv.user = user
                    rosterArray.append(inv)
                }
                
            }
            
            Utils.hideSpinner()
            let controller = ChatRoomViewController()
            controller.isGroupChat = true
            controller.chatDetailType = .classes
            controller.userNavImage = unsafe.clubHeader.userImageView.image
            controller.subclassInfo = unsafe.subclassInfo
            controller.userName = unsafe.subclassInfo?.name ?? ""
            controller.rosterArray = rosterArray
            controller.hidesBottomBarWhenPushed = true
            
            if let channels = data as? [SBDGroupChannel], channels.count > 0 {
                let filterChannel = channels.filter({ $0.data == unsafe.subclassInfo?.id })
                controller.channel = filterChannel.first
            }
            unsafe.navigationController?.pushViewController(controller, animated: true)
            }, errorHandler: { (error) in
                print(error?.localizedDescription ?? "")
        })
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
                    uwself.fillImageHeader()
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
            guard let unsafe = self else { return }
            if let post = result {
                let index = unsafe.classesPostList.firstIndex(where: { ( $0.postId == post.postId ) })
                if let position = index, unsafe.classesPostList.count > position {
                    unsafe.classesPostList[position] = post
                    unsafe.tableView.reloadData()
                }
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
