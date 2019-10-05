//
//  FriendsListLogics.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import PanModal

extension EventCategoryListViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        if type == .event {
            return eventList.count
        } else if type == .club {
            return clubList.count
        } else if type == .classes {
            return classList.count
        } else {
             return 50
        }
    }
    
    func fillCategoryCell(_ cell: EventByDateCell, _ indexPath: IndexPath) {
        
    }
    
    func fillSortingCell(_ cell: SortingCell, _ indexPath: IndexPath) {
        
        var title = ""
        if type == .none {
            title = indexPath.item == 0 ? "All upcoming" : indexPath.item == 1 ? "Any time" : "Friends"
        } else if type == .event {
            title = indexPath.item == 0 ? "All upcoming" : indexPath.item == 1 ? "Any time" : "All people"
        } else if type == .club || type == .classes {
            title = indexPath.item == 0 ? "All categories" : indexPath.item == 1 ? "Popular first" : "All people"
        }
        cell.setup(text: title)
        
        if indexPath.item == 0 {
            isFirstFilter ? cell.setup(image: #imageLiteral(resourceName: "upArrow")) : cell.setup(image: #imageLiteral(resourceName: "downArrow"))
        } else if indexPath.item == 1 {
            isSecondFilter ? cell.setup(image: #imageLiteral(resourceName: "upArrow")) : cell.setup(image: #imageLiteral(resourceName: "downArrow"))
        } else if indexPath.item == 2 {
            isThirdFilter ? cell.setup(image: #imageLiteral(resourceName: "upArrow")) : cell.setup(image: #imageLiteral(resourceName: "downArrow"))
        }
    }
    
    func collectionCellSelected(_ indexPath: IndexPath) {
        if indexPath.item == 0 {
            isFirstFilter = !isFirstFilter
        } else if indexPath.item == 1 {
            isSecondFilter = !isSecondFilter
        } else if indexPath.item == 2 {
            isThirdFilter = !isThirdFilter
        }
        
        guard let eventCategoryFilter = UIStoryboard(name: "Event", bundle: nil).instantiateViewController(withIdentifier: "EventCateogryFilterViewController") as? EventCateogryFilterViewController & PanModalPresentable else { return }
        eventCategoryFilter.dataArray = indexPath.item == 0 ? Utils.upcomingFiler() : indexPath.item == 1 ? Utils.anyTimeFilter() : Utils.friendsFilter()
        let rowViewController: PanModalPresentable.LayoutType = eventCategoryFilter
        presentPanModal(rowViewController)
        collectionView.reloadData()
    }
    
    func fillClubCell(_ cell: FriendClubCell, _ indexPath: IndexPath) {
        if type == .club {
            let club = clubList[indexPath.row]
            let image = Image(json: club.clubPhoto ?? "")
            cell.setup(title: club.clubName ?? "")
            cell.setup(detail: club.clubDesc ?? "")
            cell.setup(invitee: club.invitees)
            cell.setup(imageUrl: image.urlThumb())
        } else {
            cell.setup(detail: "SOMM 24-A")
        }
    }
    func fillEventCell(_ cell: EventByDateCell, _ indexPath: IndexPath) {
        let event = eventList[indexPath.row]
        cell.setup(title: event.title)
        cell.setup(date: event.start)
        cell.setup(start: event.start, end: event.end)
        cell.setup(eventImageUrl: event.photoJson.photo?.urlThumb())
        
      /*  cell.cellSelected = { [weak self] (type, id, index) in
            guard let unsafe = self else { return }
            if unsafe.type == .event
            {
                let event = unsafe.eventList[index]
                unsafe.performSegue(withIdentifier: Segues.eventDetailSegue, sender: event)
            }
        }*/
    }
    func cellSelected(_ indexPath: IndexPath) {
        if type == .event {
            let event = eventList[indexPath.row]
            performSegue(withIdentifier: Segues.eventDetailSegue, sender: event)
        }
    }
}

// Services
extension EventCategoryListViewController {

    func getClubListAPI(sortBy: String) {
        
        let param = [Keys.search: searchText,
                     Keys.sortBy: sortBy,
                     Keys.pageNo: pageNo] as [String: Any]
        
        if clubList.count == 0 {
            Utils.showSpinner()
        }
        
        ServiceManager.shared.fetchClubList(sortBy: sortBy, params: param) { [weak self] (value, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let clubs = value {
                unsafe.clubList = clubs
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func getEventList(sortBy: GetEventType, eventCategory: EventCategory?) {
        
        let param = [Keys.profileUserId: Authorization.shared.profile?.userId ?? "",
                     Keys.search: searchText,
                     Keys.sortBy: sortBy.rawValue,
                     Keys.eventCateId: eventCategory?.id ?? "",
                     Keys.pageNo: pageNo] as [String: Any]
        
        ServiceManager.shared.fetchEventList(sortBy: sortBy.rawValue, params: param) { [weak self] (value, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let events = value {
                unsafe.eventList = events
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func getClassCategoryAPI() {
        let param = [Keys.pageNo: pageNo] as [String: Any]
        
        ServiceManager.shared.fetchCategoryClassList(params: param) { [weak self] (data, errorMsg) in
            guard let unsafe = self else { return }
            if let classes = data {
                unsafe.classList = classes
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
