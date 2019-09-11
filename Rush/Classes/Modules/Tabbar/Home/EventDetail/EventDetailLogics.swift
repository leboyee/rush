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
        if let eventSection = sections?[section] {
            return eventSection.type
        }
        return .about
    }
    
    func sectionHeight(_ section: Int) -> CGFloat {
        if let eventSection = sections?[section], eventSection.title != nil {
            return headerHeight
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        
        if let eventSection = sections?[indexPath.section] {
            if eventSection.type == .people {
                return friendHeight
            }
        }
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        var count = 0
        if let eventSection = sections?[section] {
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
        cell.joinButtonClickEvent = { () in
            Utils.notReadyAlert()
        }
    }
    
    func fillOrganizerCell(_ cell: OrganizerCell) {
        guard let user = event?.owner else { return }
        cell.set(name: user.name)
        cell.set(detail: "3 events")
        cell.set(url: user.photo?.urlThumb())
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(isDetailArrowHide: true)
        guard let eventSection = sections?[section] else { return }
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
