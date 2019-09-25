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
        fetchUserProfile()
        fetchImagesList()
        fetchFriendList()
        fetchNotificationList()
    }
    
    func loadFriends() {
        
    }
    
    func loadNotifications() {
        
    }
}

// MARK: - Handlers
extension ProfileViewController {
    
    func sectionCount() -> Int {
        return 4
    }
    
    func sectionHeight(_ section: Int) -> CGFloat {
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
        case 0, 1, 2:
            count = 1
        case 3:
            count = 6
        default:
            count = 0
        }
        return count
    }
    
    func fillNotificationCell(_ cell: NotificationCell, _ indexPath: IndexPath) {
        cell.setup()
    }
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        cell.setup(isSeparatorHide: false)
        switch indexPath.section {
        case 0:
            cell.setup(imagesList: [])
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
            ServiceManager.shared.getProfile(params: params) { [weak self] (data, _) in
                if let object = data?[Keys.user] as? [String: Any] {
                    self?.profileDetail.profile = Authorization.shared.profileModelResponse(data: object)
                }
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
            /*
            let params = [Keys.profileUserId: userId, Keys.pageNo: "1"]
            ServiceManager.shared.getImageList(params: params, closer: { [weak self] (data, _) in
                if let list = data?[Keys.list] as? [[String: Any]] {
                    
                }
                self?.downloadGroup.leave()
            })*/
            self.downloadGroup.leave()
        }
    }
    
    private func fetchFriendList() {
        downloadQueue.async {
            let time = DispatchTime.now() + (2 * 60)
            _ = self.downloadGroup.wait(timeout: time)
            self.downloadGroup.enter()
            guard let userId = self.profileDetail.profile?.userId else { return }
            let params = [Keys.profileUserId: userId, Keys.pageNo: "1"]
            ServiceManager.shared.fetchFriendsList(params: params) { [weak self] (data, _) in
                if let list = data?[Keys.list] as? [[String: Any]] {
                    
                }
                self?.downloadGroup.leave()
            }
        }
    }
    
    private func fetchNotificationList() {
        downloadQueue.async {
            let time = DispatchTime.now() + (2 * 60)
            _ = self.downloadGroup.wait(timeout: time)
            self.downloadGroup.enter()
            guard let userId = self.profileDetail.profile?.userId else { return }

            self.downloadGroup.leave()
        }
    }
}
