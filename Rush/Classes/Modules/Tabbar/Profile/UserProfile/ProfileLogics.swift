//
//  ProfileLogics.swift
//  Rush
//
//  Created by kamal on 14/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

// MARK: - Other Function
extension ProfileViewController {

    func loadAllData() {
        loadUserProfile()
        loadImages()
        loadFriends()
        loadNotifications()
    }
    
    func loadUserProfile() {
        fetchUserProfile()
    }
    
    func loadImages() {
        imagePageNo = 1
        imageNextPageExist = false
        fetchImagesList()
    }
    
    func loadFriends() {
        friendPageNo = 1
        friendNextPageExist = false
        fetchFriendList()
    }
    
    func loadNotifications() {
        notificationPageNo = 1
        notificationNextPageExist = false
        fetchNotificationList()
    }
    
    private func handleTapOnLabel(notification: NotificationItem, text: String) {
        switch notification.ntType {
            case .acceptFriendRequest, .friendRequest: break
            case .eventInvite: break
            case .clubInvite: break
            case .upVoted, .downVoted, .newComment: break
            default: break
            }
    }
}

// MARK: - Handlers
extension ProfileViewController {
    
    func sectionCount() -> Int {
        return 4
    }
    
    func sectionHeight(_ section: Int) -> CGFloat {
        
        if section == 0, profileDetail.images?.isEmpty ?? true {
            return CGFloat.leastNormalMagnitude
        } else if section == 1, profileDetail.friends?.isEmpty ?? true {
            return CGFloat.leastNormalMagnitude
        } else if section == 2, profileDetail.interests?.isEmpty ?? true {
            return CGFloat.leastNormalMagnitude
        } else if section == 3, profileDetail.notifications?.isEmpty ?? true {
            return CGFloat.leastNormalMagnitude
        }
        
        return 47.0
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 112.0
        } else if indexPath.section == 1 {
            return 88.0
        } else {
           return UITableView.automaticDimension
        }
    }
    
    func cellCount(_ section: Int) -> Int {
        var count = 0
        switch section {
        case 0:
            if let images = profileDetail.images, !images.isEmpty {
               count = 1
            }
        case 1:
            if let friends = profileDetail.friends, !friends.isEmpty {
               count = 1
            }
        case 2:
            if let interests = profileDetail.interests, !interests.isEmpty {
               count = 1
            }
        case 3:
            count = profileDetail.notifications?.count ?? 0
        default:
            count = 0
        }
        return count
    }
    
    func fillNotificationCell(_ cell: NotificationCell, _ indexPath: IndexPath) {
        if let notification = profileDetail.notifications?[indexPath.row] {
            switch notification.ntType {
            case .acceptFriendRequest, .friendRequest:
                cell.set(friend: notification.friend?.last, text: notification.ntText)
            case .eventInvite:
                cell.set(user: notification.generatedBy, object: notification.event?.last, text: notification.ntText)
            case .clubInvite:
                cell.set(user: notification.generatedBy, object: notification.club?.last, text: notification.ntText)
            case .upVoted, .downVoted, .newComment:
                if let post = notification.post?.last {
                    if post.type.lowercased() == Text.event.lowercased() {
                        cell.set(user: notification.generatedBy, object: notification.event?.last, text: notification.ntText)
                    } else if post.type.lowercased() == Text.club.lowercased() {
                        cell.set(user: notification.generatedBy, object: notification.club?.last, text: notification.ntText)
                    } else {
                        cell.set(user: notification.generatedBy, object: notification.classObject?.last, text: notification.ntText)
                    }
                }
            default:
                cell.label.text = ""
            }
            
            cell.labelTapEvent = { [weak self] (text, range) in
                guard let unsafe = self else { return }
                let name = (text as NSString).substring(with: range)
                unsafe.handleTapOnLabel(notification: notification, text: name)
            }
        }
    }
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        cell.setup(isSeparatorHide: false)
        switch indexPath.section {
        case 0:
            if let images = profileDetail.images {
               cell.setup(imagesList: images)
            }
        case 1:
            if let friends = profileDetail.friends {
               cell.setup(friends: friends)
            }
        case 2:
            if let interests = profileDetail.interests {
               cell.setup(interests: interests)
            }
        default:
            break
        }
        
        cell.cellSelected = { [weak self] (_, _, index) in
            if indexPath.section == 0 {
                self?.showAllImages(with: index)
            } else if indexPath.section == 1 {
                if let friends = self?.profileDetail.friends {
                    let friend = friends[index] as Friend
                    self?.showFriend(user: friend)
                }
            }
        }
        
        cell.cellWillDisplay = { [weak self] (index) in
            guard let unsafe = self else { return }
            if indexPath.section == 0, unsafe.imageNextPageExist, (unsafe.profileDetail.images?.count ?? 0) - 1 == index {
                unsafe.imageNextPageExist = false
                unsafe.fetchImagesList()
            } else if indexPath.section == 1, unsafe.friendNextPageExist, (unsafe.profileDetail.friends?.count ?? 0) - 1 == index {
                unsafe.friendNextPageExist = false
                unsafe.fetchFriendList()
            }
        }
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(isDetailArrowHide: false)
        switch section {
        case 0:
            header.setup(title: Text.images)
        case 1:
            header.setup(title: Text.friends)
        case 2:
            header.setup(title: Text.interests)
        case 3:
            header.setup(title: Text.notifications)
            header.setup(isDetailArrowHide: true)
        default:
            header.setup(title: "")
        }
        
        header.detailButtonClickEvent = { [weak self] () in
            if section == 0 {
                self?.showAllImages(with: 0)
            } else if section == 1 {
                self?.showAllFriends()
            } else if section == 2 {
                self?.showAllInterests()
            }
        }
    }
    
    func selectedRow(_ indexPath: IndexPath) {
        
    }
    
    func willDisplay(_ indexPath: IndexPath) {
        if indexPath.section == 3, notificationNextPageExist, (profileDetail.notifications?.count ?? 0) - 1 == indexPath.row {
            notificationNextPageExist = false
            fetchNotificationList()
        }
    }
}

// MARK: - API's
extension ProfileViewController {

    private func fetchUserProfile() {
        downloadQueue.async {
            let time = DispatchTime.now() + (2 * 60)
            _ = self.downloadGroup.wait(timeout: time)
            self.downloadGroup.enter()
            guard let userId = self.profileDetail.profile?.userId else { return }
            guard userId.isNotEmpty else { return }
            let params = self.isOtherUserProfile ? [Keys.profileUserId: userId] : [:]
            ServiceManager.shared.getProfile(params: params) { [weak self] (user, _) in
                self?.profileDetail.profile = user
                self?.profileDetail.interests = user?.interest

                self?.setupHeaderData()
                self?.downloadGroup.leave()
            }
        }
    }
    
    private func fetchImagesList() {
        downloadQueue.async {
            let time = DispatchTime.now() + (2 * 60)
            _ = self.downloadGroup.wait(timeout: time)
            self.downloadGroup.enter()
            guard let userId = self.profileDetail.profile?.userId else { return }
            let params = [Keys.profileUserId: userId, Keys.pageNo: "\(self.imagePageNo)"]
            ServiceManager.shared.getImageList(params: params, closer: { [weak self] (data, _) in
                guard let unsafe = self else { return }
                if let list = data?[Keys.images] as? [[String: Any]] {
                    if list.isEmpty {
                        unsafe.imageNextPageExist = false
                        if unsafe.imagePageNo == 1 {
                            unsafe.profileDetail.images?.removeAll()
                        }
                    } else {
                        var items = [Image]()
                        for item in list {
                            if let json = item["img_data"] as? String {
                                let image = Image(json: json)
                                items.append(image)
                            }
                        }
                        if unsafe.imagePageNo == 1 {
                            unsafe.profileDetail.images = items
                        } else {
                            unsafe.profileDetail.images?.append(contentsOf: items)
                        }
                        unsafe.imagePageNo += 1
                        unsafe.imageNextPageExist = true
                    }
                }
                self?.downloadGroup.leave()
            })
        }
    }
    
    private func fetchFriendList() {
        downloadQueue.async {
            let time = DispatchTime.now() + (2 * 60)
            _ = self.downloadGroup.wait(timeout: time)
            self.downloadGroup.enter()
            guard let userId = self.profileDetail.profile?.userId else { return }
            let params = [Keys.profileUserId: userId, Keys.pageNo: "\(self.friendPageNo)"]
            ServiceManager.shared.fetchFriendsList(params: params) { [weak self] (friends, _) in
                guard let unsafe = self else { return }
                if let list = friends {
                    if list.isEmpty {
                        unsafe.friendNextPageExist = false
                        if unsafe.friendPageNo == 1 {
                            unsafe.profileDetail.notifications?.removeAll()
                        }
                    } else {
                        if unsafe.friendPageNo == 1 {
                            unsafe.profileDetail.friends = list
                        } else {
                            unsafe.profileDetail.friends?.append(contentsOf: list)
                        }
                        unsafe.friendPageNo += 1
                        unsafe.friendNextPageExist = true
                    }
                }
                self?.downloadGroup.leave()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func fetchNotificationList() {
        downloadQueue.async {
            let time = DispatchTime.now() + (2 * 60)
            _ = self.downloadGroup.wait(timeout: time)
            self.downloadGroup.enter()
            let params = [Keys.pageNo: "\(self.notificationPageNo)"]
            ServiceManager.shared.fetchNotificationList(params: params) { [weak self] (notifications, _) in
                guard let unsafe = self else { return }
                if let list = notifications {
                    if list.isEmpty {
                        unsafe.notificationNextPageExist = false
                        if unsafe.notificationPageNo == 1 {
                            unsafe.profileDetail.notifications?.removeAll()
                        }
                    } else {
                        if unsafe.notificationPageNo == 1 {
                            unsafe.profileDetail.notifications = list
                        } else {
                            unsafe.profileDetail.notifications?.append(contentsOf: list)
                        }
                        unsafe.notificationPageNo += 1
                        unsafe.notificationNextPageExist = true
                    }
                }
                self?.downloadGroup.leave()
                self?.tableView.reloadData()
            }
        }
    }
}
