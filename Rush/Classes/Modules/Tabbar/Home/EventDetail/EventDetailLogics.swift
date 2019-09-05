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
        return sections?.count ?? 0
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
            cell.setup(userList: [])
        }
        
        cell.cellSelected = { [weak self] (_, _, index) in
            
        }
    }
    
    func fillManageCell(_ cell: ClubManageCell) {
        cell.setup(firstButtonType: .manage)
        cell.setup(secondButtonType: .groupChatClub)
        
        cell.firstButtonClickEvent = { [weak self] () in
            guard let _ = self else { return }
            Utils.notReadyAlert()
        }
        
        cell.secondButtonClickEvent = { [weak self] () in
            guard let _ = self else { return }
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
        }
        
        // TODO: Dummuy Event
        event = Event()
        event?.title = "Harvard gaming"
        event?.desc = "We going to enjoy VR videogames, will see art exhibitions and much more!"
        event?.date = Date().plus(days: 7)
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
        tableView.reloadData()
    }
}
