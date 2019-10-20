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
    
    func deleteEvent(event: Event) {
        deleteEventAPI(id: String(event.id))
    }
    
    func deletePost(post: Post) {
        deletePostAPI(id: post.postId)
    }
    
    func loadEventSection() {
        guard let event = self.event else { return }
        if event.creator?.userId == Authorization.shared.profile?.userId {
            type = .my
        } else if let eventInvite = event.eventInvite?.last {
            type = eventInvite.status == 1 ? .joined : .invited
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
                EventSection(type: .createPost, title: "Posts")
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
        } else if indexPath.row == 2, post.images?.count ?? 0 > 0 {
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
                var height = screenWidth
                if count > 1 {
                    height = (CGFloat(count) / 2.0) * (screenWidth / 2.0)
                }
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
                count = post.images?.count ?? 0 == 0 ? 3 : 4
            }
        } else if let eventSection = sections?[section] {
            switch eventSection.type {
            case .about, .joinRsvp, .location, .manage, .organizer, .createPost:
                count = 1
            case .tags:
                if (event?.interests?.count ?? 0) > 0 {
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
        cell.readMoreEvent = { [weak self] () in
            self?.reloadTable()
        }
    }
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        
        guard let eventSection = sections?[indexPath.section] else { return }
        cell.setup(isSeparatorHide: true)
        if eventSection.type == .tags {
            cell.setup(interests: event?.interests ?? [])
        } else if eventSection.type == .invitee, let list = inviteeList {
            cell.setup(invitees: list, total: self.totalInvitee)
        }
        
        cell.userSelected = { [weak self] ( id, index) in
            if index == 0 {
                // show all invitee list
                self?.showInvitedPeopleList()
            } else if let list = self?.inviteeList {
                let invitee = list[index - 1]
                self?.showInviteeUserProfile(invitee: invitee)
            }
        }
        
        cell.cellSelected = { [weak self] (_, _, index) in
            if cell.cellType == .interests, let interest = self?.event?.interests?[index] {
                self?.showInterestBasedEvent(interest)
            }
        }
    }
    
    func fillManageCell(_ cell: ClubManageCell) {
        cell.firstButton.isUserInteractionEnabled = true
        cell.messageButton.isUserInteractionEnabled = true
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
            /// Disable interaction with going button
            if event?.isChatGroup == true {
               cell.setup(firstButtonType: .going)
               cell.setup(secondButtonType: .groupChatClub)
               cell.firstButton.isUserInteractionEnabled = false
            } else {
               cell.setup(onlyFirstButtonType: .going)
               cell.messageButton.isUserInteractionEnabled = false
            }
        }
        
        cell.firstButtonClickEvent = { [weak self] () in
            guard let unsafe = self else { return }
            if unsafe.type == .invited {
                /// Call Accept  API
                guard let event = unsafe.event else { return }
                if event.rsvp?.count ?? 0 == 0 {
                    unsafe.joinEvent(eventId: String(event.id), action: EventAction.accept)
                } else {
                    unsafe.showRSVP(action: EventAction.accept)
                }
            } else if unsafe.type == .my {
                /// Show Edit event api
                unsafe.performSegue(withIdentifier: Segues.editEventSegue, sender: self)
            }
        }
        
        cell.secondButtonClickEvent = { [weak self] () in
            guard let unsafe = self else { return }
            if unsafe.type == .joined || unsafe.type == .my {
                unsafe.openGroupChat()
            } else if unsafe.type == .invited {
                // Call Reject API
                guard let event = unsafe.event else { return }
                unsafe.rejectEvent(eventId: String(event.id))
            }
        }
        
    }
    
    func fillLocationCell(_ cell: LocationCell) {
        cell.set(address: event?.address ?? "", lat: event?.latitude ?? "0", lon: event?.longitude ?? "0")
        cell.showLocationOnMap = { [weak self] () in
            self?.showLocationOnMap()
        }
    }
    
    func fillCreatePostCell(_ cell: CreatePostCell) {
        if let user = Authorization.shared.profile {
            cell.set(url: user.photo?.urlThumb())
        }
    }
    
    func fillSingleButtonCell(_ cell: SingleButtonCell) {
        guard let event = self.event else { return }
        if event.rsvp?.count ?? 0 == 0 {
            cell.setup(title: Text.join)
        } else {
            cell.setup(title: Text.joinAndRSVP)
        }
        
        cell.joinButtonClickEvent = { [weak self] () in
            guard let unsafe = self else { return }
            if event.rsvp?.count ?? 0 == 0 {
                unsafe.joinEvent(eventId: String(event.id), action: EventAction.join)
            } else {
                unsafe.showRSVP(action: EventAction.join)
            }
        }
    }
    
    func fillOrganizerCell(_ cell: OrganizerCell) {
        guard let user = event?.creator else { return }
        cell.set(name: user.name)
        let text =  "\(user.totalEvents ?? 0) events"
        cell.set(detail: text)
        cell.set(url: user.photo?.urlThumb())
    }
    
    func fillPostUserCell(_ cell: PostUserCell, _ indexPath: IndexPath) {
        let index = indexPath.section - (sections?.count ?? 0)
        if let post = postList?[index] {
            cell.set(name: post.user?.name ?? "")
            cell.set(time: post.createDate)
            cell.set(url: post.user?.photo?.urlThumb())
            cell.moreEvent = { [weak self] () in
                guard let unsafe = self else { return }
                unsafe.sharePost(post: post)
            }
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
            cell.set(images: post.images)
            cell.showImages = { [weak self] (index) in
                guard let unsafe = self else { return }
                unsafe.showPostImages(post: post, index: index)
            }
        }
    }
    
    func fillPostBottomCell(_ cell: PostBottomCell, _ indexPath: IndexPath) {
        let index = indexPath.section - (sections?.count ?? 0)
        if let post = postList?[index] {
            cell.set(numberOfLike: post.totalUpVote)
            cell.set(numberOfComment: post.numberOfComments)
            if let myVote = post.myVote?.first {
                cell.set(vote: myVote.type)
            } else {
               cell.set(vote: 0)
            }
            
            cell.likeButtonEvent = { [weak self] () in
                self?.voteAPI(id: post.postId, type: Vote.up)
            }
            
            cell.unlikeButtonEvent = { [weak self] () in
                self?.voteAPI(id: post.postId, type: Vote.down)
            }
            
            cell.commentButtonEvent = { [weak self] () in
                self?.showComments(post: post)
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
            } else if eventSection.type == .organizer {
                guard let user = event?.creator else { return }
                showUserProfile(user: user)
            }
        }
    }
    
    func willDisplay(_ indexPath: IndexPath) {
        let totalSection = tableView.numberOfSections
        /// Post list should be exist and here each section will define one post.
        guard totalSection > (sections?.count ?? 0) else { return }
        if isPostNextPageExist, totalSection - 1 == indexPath.section, indexPath.row == 0 {
           fetchPosts()
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
                  unsafe.updateHeaderInfo()
                  unsafe.downloadGroup.leave()
              }
        }
    }
    
    private func fetchInvitees() {
        downloadQueue.async {
            let time = DispatchTime.now() + (2 * 60)
            _ = self.downloadGroup.wait(timeout: time)
            self.downloadGroup.enter()
            guard let id = self.eventId, id.isNotEmpty else { return }
            
            let param = [Keys.pageNo: 1]
            ServiceManager.shared.fetchInviteeList(eventId: id, params: param) { [weak self] (invitees, total, _) in
                guard let unsafe = self else { return }
                unsafe.inviteeList = invitees
                unsafe.totalInvitee = total
                unsafe.downloadGroup.leave()
                unsafe.reloadTable()
            }
        }
    }
    
    private func fetchPosts() {
        downloadQueue.async {
            let time = DispatchTime.now() + (2 * 60)
            _ = self.downloadGroup.wait(timeout: time)
            self.downloadGroup.enter()
            guard let id = self.eventId, id.isNotEmpty else { return }
            
            let param = [Keys.pageNo: self.postPageNo]
            ServiceManager.shared.getPostList(dataId: id, type: Text.event, params: param) { [weak self] (posts, _) in
                guard let unsafe = self else { return }
                if let list = posts {
                    if list.isEmpty {
                        unsafe.isPostNextPageExist = false
                        if unsafe.postPageNo == 1 {
                            unsafe.postList?.removeAll()
                        }
                    } else {
                        if unsafe.postPageNo == 1 {
                            unsafe.postList = list
                        } else {
                            unsafe.postList?.append(contentsOf: list)
                        }
                        unsafe.postPageNo += 1
                        unsafe.isPostNextPageExist = true
                    }
                }
                unsafe.downloadGroup.leave()
                unsafe.reloadTable()
            }
        }
    }
    
    private func voteAPI(id: String, type: String) {
        ServiceManager.shared.votePost(postId: id, voteType: type) { [weak self] (result, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let post = result {
                let index = unsafe.postList?.firstIndex(where: { ( $0.postId == post.postId ) })
                if let position = index, unsafe.postList?.count ?? 0 > position {
                        unsafe.postList?[position] = post
                        unsafe.reloadTable()
                }
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    private func deleteEventAPI(id: String) {
       Utils.showSpinner()
       ServiceManager.shared.deleteEvent(eventId: id) { [weak self] (status, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if status {
                unsafe.deleteEventSuccessfully()
            } else if let message = errorMsg {
                unsafe.showMessage(message: message)
            }
        }
    }
    
   private func deletePostAPI(id: String) {
       Utils.showSpinner()
       ServiceManager.shared.deletePost(postId: id, params: [:]) { [weak self] (status, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if status {
                if let index = unsafe.postList?.firstIndex(where: { $0.postId == id }) {
                    unsafe.postList?.remove(at: index)
                    unsafe.reloadTable()
                }
            } else if let message = errorMsg {
                unsafe.showMessage(message: message)
            }
        }
    }
    
    private func joinEvent(eventId: String, action: String) {
        Utils.showSpinner()
        ServiceManager.shared.joinEvent(eventId: eventId, action: action, params: [:]) { [weak self] (data, errorMessage) in
            if data != nil {
                /*
                /// Comment due to task https://www.wrike.com/open.htm?id=411254195
                if let object = data {
                let isFirstTime = object[Keys.isFirstJoin] as? Int ?? 0
                if isFirstTime == 1 {
                   self?.showJoinAlert()
                } */
                self?.type = .joined
                DispatchQueue.main.async {
                    self?.loadAllData()
                }
            } else if let message = errorMessage {
                self?.showMessage(message: message)
                Utils.hideSpinner()
            }
        }
    }
    
    private func rejectEvent(eventId: String) {
        Utils.showSpinner()
        ServiceManager.shared.rejectEventInvitation(eventId: eventId) { [weak self] (status, errorMessage) in
            if status {
                self?.loadAllData()
            } else if let message = errorMessage {
                self?.showMessage(message: message)
                Utils.hideSpinner()
            }
        }
    }
}
