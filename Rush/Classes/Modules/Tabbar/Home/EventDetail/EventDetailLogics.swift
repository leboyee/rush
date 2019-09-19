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
        fetchEventDetails()
    }
    
    func loadFriends() {
        
    }
}

// MARK: - Handlers
extension EventDetailViewController {
    
    func sectionCount() -> Int {
        var sectionCount = sections?.count ?? 0
        sectionCount += postlist?.count ?? 0
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
        guard let post = postlist?[index] else { return .none }
        
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
            return headerHeight
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section > (sections?.count ?? 0) - 1, postCellType(indexPath: indexPath) == .image {
            let index = indexPath.section - (sections?.count ?? 0)
            if let post = postlist?[index] {
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
            if eventSection.type == .people {
                return friendHeight
            }
        }
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        var count = 0
        if section >= sections?.count ?? 0 {
            let index = section - (sections?.count ?? 0)
            if let post = postlist?[index] {
                count = post.images == nil ? 3 : 4
            }
        } else if let eventSection = sections?[section] {
            switch eventSection.type {
            case .about, .joinRsvp, .location, .manage, .people, .tags, .organizer, .createPost:
                count = 1
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
            cell.setup(interests: [Tag(id: 111, text: "Development"), Tag(id: 211, text: "Technologies")])
        } else if eventSection.type == .people {
            cell.setup(userList: tempInvitee)
        }
        
        cell.cellSelected = { (_, _, _) in
            
        }
    }
    
    func fillManageCell(_ cell: ClubManageCell) {
        
        if type == .my {
            cell.setup(firstButtonType: .manage)
            cell.setup(secondButtonType: .groupChat)
        } else if type == .invited {
            cell.setup(firstButtonType: .accept)
            cell.setup(secondButtonType: .reject)
        } else if type == .joined {
            cell.setup(firstButtonType: .going)
            cell.setup(secondButtonType: .groupChatClub)
        }
        
        cell.firstButtonClickEvent = { () in
            Utils.notReadyAlert()
        }
        
        cell.secondButtonClickEvent = { () in
            Utils.notReadyAlert()
        }
    }
    
    func fillLocationCell(_ cell: LocationCell) {
        if let address = event?.address {
           cell.set(address: address)
        }
    }
    
    func fillCreatePostCell(_ cell: CreatePostCell) {
       
    }
    
    func fillSingleButtonCell(_ cell: SingleButtonCell) {
        cell.setup(title: Text.joinAndRSVP)
        cell.joinButtonClickEvent = { [weak self] () in
            self?.showRSVP()
        }
    }
    
    func fillOrganizerCell(_ cell: OrganizerCell) {
        guard let user = event?.owner else { return }
        cell.set(name: user.name)
        cell.set(detail: "3 events")
        cell.set(url: user.photo?.urlThumb())
    }
    
    func fillPostUserCell(_ cell: PostUserCell, _ indexPath: IndexPath) {
        let index = indexPath.section - (sections?.count ?? 0)
        if let post = postlist?[index] {
            cell.set(name: post.user?.name ?? "")
            cell.set(time: post.createDate)
            cell.set(url: nil)
        }
    }
    
    func fillPostTextCell(_ cell: PostTextCell, _ indexPath: IndexPath) {
        let index = indexPath.section - (sections?.count ?? 0)
        if let post = postlist?[index] {
            cell.set(text: post.text ?? "")
        }
    }
    
    func fillPostImageCell(_ cell: PostImagesCell, _ indexPath: IndexPath) {
        let index = indexPath.section - (sections?.count ?? 0)
        if let post = postlist?[index] {
            cell.set(images: post.photos)
        }
    }
    
    func fillPostBottomCell(_ cell: PostBottomCell, _ indexPath: IndexPath) {
        let index = indexPath.section - (sections?.count ?? 0)
        if let post = postlist?[index] {
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
        
    }
}

// MARK: - API's
extension EventDetailViewController {
    
    private func fetchEventDetails() {
        
        //guard let id = eventId, id.isNotEmpty else { return }
        
        if type == .my {
            sections = [
                EventSection(type: .about, title: nil),
                EventSection(type: .manage, title: nil),
                EventSection(type: .location, title: "Location"),
                EventSection(type: .people, title: "Invited people"),
                EventSection(type: .tags, title: "Interest tags"),
                EventSection(type: .createPost, title: "Posts")
            ]
        } else if type == .other {
            sections = [
                EventSection(type: .about, title: nil),
                EventSection(type: .location, title: "Location"),
                EventSection(type: .people, title: "Joined"),
                EventSection(type: .organizer, title: "Organizer"),
                EventSection(type: .tags, title: "Interest tags"),
                EventSection(type: .joinRsvp, title: nil)
            ]
        } else if type == .joined {
            sections = [
                EventSection(type: .about, title: nil),
                EventSection(type: .manage, title: nil),
                EventSection(type: .location, title: "Location"),
                EventSection(type: .people, title: "Joined"),
                EventSection(type: .organizer, title: "Organizer"),
                EventSection(type: .tags, title: "Interest tags"),
                EventSection(type: .createPost, title: "Popular posts")
            ]
            
            let post = Post()
            let user = User()
            user.firstName = "Kamal"
            user.lastName = "Mittal"
            post.user = user
            post.id = UUID().uuidString
            post.text = "Everyone who joined - you going to have a great time! I promise!"
            post.numberOfLikes = 2
            post.numberOfComments = 12
            
            let image1 = Image(
                url: "https://www.liulishenshe.com/Simplify_admin/images/profile/profile4.jpg"
            )
            
            let image2 = Image(
                url: "http://www.fedracongressi.com/fedra/wp-content/uploads/2016/02/revelry-event-designers-homepage-slideshow-38.jpeg"
            )
            
            let image3 = Image(
                url: "https://www.brc.com.au/Images/UserUploadedImages/11/outdoor-event.jpg"
            )
            
            let image4 = Image(
                url: "https://www.brc.com.au/Images/UserUploadedImages/11/birthday-event.jpg"
            )
            
            let image5 = Image(
                url: "https://www.brc.com.au/Images/UserUploadedImages/11/trade-event.jpg"
            )
            
            let image6 = Image(
                url: "https://www.brc.com.au/Images/UserUploadedImages/11/cocktail-event.jpg"
            )
            
            let image7 = Image(
                url: "https://www.brc.com.au/Images/UserUploadedImages/11/outdoor-event.jpg"
            )
            post.images = [image1, image2, image3, image4, image5, image6, image7]
            
            let post2 = Post()
            let user2 = User()
            user2.firstName = "John"
            user2.lastName = "Smith"
            post2.user = user2
            post2.id = UUID().uuidString
            post2.text = "Everyone who joined - you going to have a great time! I promise!"
            post2.numberOfLikes = 43
            post2.numberOfComments = 23
            
            postlist = [post, post2]
            
        } else if type == .invited {
            sections = [
                EventSection(type: .about, title: nil),
                EventSection(type: .manage, title: nil),
                EventSection(type: .location, title: "Location"),
                EventSection(type: .people, title: "Joined"),
                EventSection(type: .organizer, title: "Organizer"),
                EventSection(type: .tags, title: "Interest tags")
            ]
        }
        
        // TODO: Dummuy Event
        event = Event()
        event?.title = "Harvard gaming"
        event?.desc = "We going to enjoy VR videogames, will see art exhibitions and much more!"
        event?.date = Date().plus(days: 7)
        event?.start = event?.date
        event?.end = event?.date?.plus(hours: 1)
        event?.type = "event"
        event?.eventType = .closed
        event?.address = Address()
        event?.address?.addressline = "23 East Lake Forest Drive"
        event?.address?.city = "Flushing"
        event?.address?.state = "NY"
        event?.address?.zipcode = "11355"
        event?.address?.country = "USA"
        event?.address?.latitude = 40.768452
        event?.address?.longitude = -73.832764
        event?.thumbnil = "http://www.fedracongressi.com/fedra/wp-content/uploads/2016/02/revelry-event-designers-homepage-slideshow-38.jpeg"
        let user = Profile()
        user.firstName = "Kamal"
        user.lastName = "Mittal"
        user.photo = Image(
            url: "https://www.liulishenshe.com/Simplify_admin/images/profile/profile4.jpg"
        )
        event?.owner = user
        tableView.reloadData()
        updateHeaderInfo()
    }
}
