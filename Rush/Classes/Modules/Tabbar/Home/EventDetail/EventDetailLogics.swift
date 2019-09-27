//
//  EventDetailLogics.swift
//  Rush
//
//  Created by kamal on 27/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//
import UIKit

// MARK: - Other Function
extension EventDetailViewController {
    
    func loadAllData() {
        loadEvent()
        loadInvitees()
    }
    
    func loadEvent() {
        fetchEventDetails()
    }
    
    func loadInvitees() {
        fetchInvitees()
    }
    
    func loadPosts() {
        postPageNo = 1
        isPostNextPageExist = false
        fetchPosts()
    }
    
    func loadEventSection() {
        guard let event = self.event else { return }
        if event.creator?.id == Authorization.shared.profile?.userId {
            type = .my
        } else {
            type = .other
        }
        
        if type == .my {
            sections = [
                EventSection(type: .about, title: nil),
                EventSection(type: .manage, title: nil),
                EventSection(type: .location, title: "Location"),
                EventSection(type: .invitee, title: "Invited people"),
                EventSection(type: .tags, title: "Interest tags"),
                EventSection(type: .createPost, title: "Posts")
            ]
            /// Need to call post list here
                loadPosts()
        } else if type == .other {
            sections = [
                EventSection(type: .about, title: nil),
                EventSection(type: .location, title: "Location"),
                EventSection(type: .invitee, title: "Joined"),
                EventSection(type: .organizer, title: "Organizer"),
                EventSection(type: .tags, title: "Interest tags"),
                EventSection(type: .joinRsvp, title: nil)
            ]
        } else if type == .joined {
            sections = [
                EventSection(type: .about, title: nil),
                EventSection(type: .manage, title: nil),
                EventSection(type: .location, title: "Location"),
                EventSection(type: .invitee, title: "Joined"),
                EventSection(type: .organizer, title: "Organizer"),
                EventSection(type: .tags, title: "Interest tags"),
                EventSection(type: .createPost, title: "Popular posts")
            ]
            
            /// Need to call post list here
                loadPosts()
        } else if type == .invited {
            sections = [
                EventSection(type: .about, title: nil),
                EventSection(type: .manage, title: nil),
                EventSection(type: .location, title: "Location"),
                EventSection(type: .invitee, title: "Joined"),
                EventSection(type: .organizer, title: "Organizer"),
                EventSection(type: .tags, title: "Interest tags")
            ]
        }
    }
}

// MARK: - Handlers
extension EventDetailViewController {
    
    func sectionCount() -> Int {
        var sectionCount = sections?.count ?? 0
        sectionCount += postList?.count ?? 0
        return sectionCount
    }
    
    func sectionType(section: Int) -> EventSectionType {
        if section >= sections?.count ?? 0 {
            return .post
        } else {
            let eventSection = sections?[section]
            return eventSection?.type ?? .about
        }
    }
    
    func postCellType(indexPath: IndexPath) -> PostCellType {
        let index = indexPath.section - (sections?.count ?? 0)
        guard let post = postList?[index] else { return .none }
        
        if indexPath.row == 0 {
            return .user
        } else if indexPath.row == 1 {
            return .text
        } else if indexPath.row == 2, post.images != nil {
            return .image
        } else {
            return .like
        }
    }
    
    func sectionHeight(_ section: Int) -> CGFloat {
        
        if section < sections?.count ?? 0, let eventSection = sections?[section], eventSection.title != nil {
            if eventSection.type == .invitee, inviteeList?.isEmpty ?? true {
                return CGFloat.leastNormalMagnitude
            } else if eventSection.type == .tags, event?.interests?.isEmpty ?? true {
                return CGFloat.leastNormalMagnitude
            }
            return headerHeight
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func sectionFooter(_ section: Int) -> CGFloat {
        if section < sections?.count ?? 0, let eventSection = sections?[section] {
            if eventSection.type == .invitee, inviteeList?.isEmpty ?? true {
                return CGFloat.leastNormalMagnitude
            } else if eventSection.type == .tags, event?.interests?.isEmpty ?? true {
                return CGFloat.leastNormalMagnitude
            }
        }
        return 1.0
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section > (sections?.count ?? 0) - 1, postCellType(indexPath: indexPath) == .image {
            let index = indexPath.section - (sections?.count ?? 0)
            if let post = postList?[index] {
                let itemsCount = post.images?.count ?? 0
                var count = itemsCount % 2 == 0 ? itemsCount : itemsCount - 1
                if itemsCount == 1 {
                    count = 1
                } else if itemsCount >= 6 {
                    count = 6
                }
                let height = (CGFloat(count) / 2.0) * (screenWidth / 2.0)
                return height
            }
        } else if indexPath.section < sections?.count ?? 0, let eventSection = sections?[indexPath.section] {
            if eventSection.type == .invitee {
                return friendHeight
            }
        }
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        var count = 0
        if section >= sections?.count ?? 0 {
            let index = section - (sections?.count ?? 0)
            if let post = postList?[index] {
                count = post.images == nil ? 3 : 4
            }
        } else if let eventSection = sections?[section] {
            switch eventSection.type {
            case .about, .joinRsvp, .location, .manage, .organizer, .createPost:
                count = 1
            case .tags:
                if event?.interests?.isNotEmpty ?? false {
                    count = 1
                }
            case .invitee:
                if !(inviteeList?.isEmpty ?? true) {
                    count = 1
                }
            default: break
            }
        }
        return count
    }
    
    func fillAboutCell(_ cell: EventAboutCell, _ indexPath: IndexPath) {
        guard let event = event else { return }
        cell.set(title: event.title)
        cell.set(type: event.eventType)
        cell.set(detail: event.desc)
        cell.set(isHideReadMore: true)
    }
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        
        guard let eventSection = sections?[indexPath.section] else { return }
        cell.setup(isSeparatorHide: true)
        if eventSection.type == .tags {
            cell.setup(interests: event?.interests?.tags ?? [])
        } else if eventSection.type == .invitee, let list = inviteeList {
            cell.setup(invitees: list)
        }
        
        cell.userSelected = { ( _, _) in
            Utils.notReadyAlert()
        }
        
        cell.cellSelected = { (_, _, _) in
            Utils.notReadyAlert()
        }
    }
    
    func fillManageCell(_ cell: ClubManageCell) {
        if type == .my {
            if event?.isChatGroup == true {
                cell.setup(firstButtonType: .manage)
                cell.setup(secondButtonType: .groupChat)
            } else {
                cell.setup(onlyFirstButtonType: .manage)
            }
        } else if type == .invited {
            cell.setup(firstButtonType: .accept)
            cell.setup(secondButtonType: .reject)
        } else if type == .joined {
            if event?.isChatGroup == true {
               cell.setup(firstButtonType: .going)
               cell.setup(secondButtonType: .groupChatClub)
            } else {
               cell.setup(onlyFirstButtonType: .going)
            }
        }
        
        cell.firstButtonClickEvent = { () in
            Utils.notReadyAlert()
        }
        
        cell.secondButtonClickEvent = { () in
            Utils.notReadyAlert()
        }
        
    }
    
    func fillLocationCell(_ cell: LocationCell) {
        cell.set(address: event?.address ?? "", lat: event?.latitude ?? "0", lon: event?.longitude ?? "0")
    }
    
    func fillCreatePostCell(_ cell: CreatePostCell) {
        if let user = Authorization.shared.profile {
            cell.set(url: user.photo?.urlThumb())
        }
    }
    
    func fillSingleButtonCell(_ cell: SingleButtonCell) {
        cell.setup(title: Text.joinAndRSVP)
        cell.joinButtonClickEvent = { [weak self] () in
            self?.showRSVP()
        }
    }
    
    func fillOrganizerCell(_ cell: OrganizerCell) {
        guard let user = event?.creator else { return }
        cell.set(name: user.name)
        cell.set(detail: "3 events")
        //cell.set(url: user.photo?.urlThumb())
    }
    
    func fillPostUserCell(_ cell: PostUserCell, _ indexPath: IndexPath) {
        let index = indexPath.section - (sections?.count ?? 0)
        if let post = postList?[index] {
            cell.set(name: post.user?.name ?? "")
            cell.set(time: post.createDate)
            cell.set(url: nil)
        }
    }
    
    func fillPostTextCell(_ cell: PostTextCell, _ indexPath: IndexPath) {
        let index = indexPath.section - (sections?.count ?? 0)
        if let post = postList?[index] {
            cell.set(text: post.text ?? "")
        }
    }
    
    func fillPostImageCell(_ cell: PostImagesCell, _ indexPath: IndexPath) {
        let index = indexPath.section - (sections?.count ?? 0)
        if let post = postList?[index] {
            cell.set(images: post.imageJson?.photos)
        }
    }
    
    func fillPostBottomCell(_ cell: PostBottomCell, _ indexPath: IndexPath) {
        let index = indexPath.section - (sections?.count ?? 0)
        if let post = postList?[index] {
            cell.set(numberOfLike: post.numberOfLikes)
            cell.set(numberOfComment: post.numberOfComments)
            
            cell.likeButtonEvent = { () in
                Utils.notReadyAlert()
            }
            
            cell.unlikeButtonEvent = { () in
                Utils.notReadyAlert()
            }
            
            cell.commentButtonEvent = { () in
                Utils.notReadyAlert()
            }
        }
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(isDetailArrowHide: true)
        guard section < sections?.count ?? 0, let eventSection = sections?[section] else { return }
        header.setup(title: eventSection.title ?? "")
    }
    
    func selectedRow(_ indexPath: IndexPath) {
        if indexPath.section < sections?.count ?? 0, let eventSection = sections?[indexPath.section] {
            /// check section type is create post or not, if yes, move to create post screen
            if eventSection.type == .createPost {
                showCreatePost()
            }
        }
    }
}

// MARK: - API's
extension EventDetailViewController {
    
    private func fetchEventDetails() {
       downloadQueue.async {
            let time = DispatchTime.now() + (2 * 60)
            _ = self.downloadGroup.wait(timeout: time)
            self.downloadGroup.enter()
            guard let id = self.eventId, id.isNotEmpty else { return }
            ServiceManager.shared.fetchEventDetail(eventId: id) { [weak self] (event, _) in
                  guard let unsafe = self else { return }
                  unsafe.event = event
                  unsafe.loadEventSection()
                  unsafe.downloadGroup.leave()
              }
        }
        updateHeaderInfo()
    }
    
    private func fetchInvitees() {
    
    }
    
    private func fetchPosts() {
       
    }
}
