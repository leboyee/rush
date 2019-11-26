//
//  EventListLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 13/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import PanModal
typealias EventCategoryItem = (key: String, event: [Event])

extension EventListViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return 50 //CGFloat.leastNormalMagnitude
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 8
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        
        return self.isMyEvents == true && indexPath.section == 0 ? 88 : 157 // eventList.count > 0 ? 157 : 157//CGFloat.leastNormalMagnitude
    }
    
    func cellCount(_ section: Int) -> Int {
        return self.isMyEvents == true && section == 0 ? eventList.count : 1
    }
        
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        let interest = eventCategory[isMyEvents == true ?  indexPath.section - 1 : indexPath.section]
        cell.setup(.upcoming, nil, interest.eventList)
        // (type, images, data)
        cell.cellSelected = { [weak self] (type, id, index) in
            guard let unsafe = self else { return }
            let event = interest.eventList?[index]
            unsafe.showEvent(event: event)
        }
        cell.joinSelected = { [weak self] (index) in
            guard let unsafe = self else { return }
            let event = interest.eventList?[index]
            if event?.rsvp?.count ?? 0 == 0 {
                unsafe.joinEvent(eventId: "\(event?.id ?? 0)", action: EventAction.join)
            } else {
                unsafe.showRSVP(event: event ?? Event())
            }

        }

    }
    
    func fillEventByDateCell(_ cell: EventByDateCell, _ indexPath: IndexPath) {
        let event = eventList[indexPath.row]
        cell.setup(cornerRadius: 24)
        cell.setup(isHideSeparator: false)
        cell.setup(title: event.title)
        cell.setup(date: event.start)
        cell.setup(start: event.start, end: event.end)
        cell.setup(eventImageUrl: event.photo?.urlThumb())
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        if self.isMyEvents == true && indexPath.section == 0 {
            let event = eventList[indexPath.row]
            performSegue(withIdentifier: Segues.eventListToEventDetailsSegue, sender: event)
        }
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        var categoryName = ""
        if self.isMyEvents == true && section == 0 {
            categoryName = "My upcoming events"
            header.setup(detailArrowImage: UIImage(named: "brown_down") ?? UIImage())
        } else {
            let eventCategoryObject = eventCategory[self.isMyEvents == true ? section - 1 : section]
            categoryName = eventCategoryObject.interestName
            header.setup(detailArrowImage: UIImage(named: "red-arrow") ?? UIImage())
        }
        header.setup(title: categoryName)
        header.detailButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            if unself.isMyEvents == true && section == 0 {
                guard let eventCategoryFilter = UIStoryboard(name: "Event", bundle: nil).instantiateViewController(withIdentifier: "EventCateogryFilterViewController") as? EventCateogryFilterViewController & PanModalPresentable else { return }
                    eventCategoryFilter.dataArray = Utils.myUpcomingFileter()
                    eventCategoryFilter.delegate = self
                eventCategoryFilter.selectedIndex = unself.eventFilterType == .myUpcoming ? 0 : 1
                eventCategoryFilter.headerTitle = "Sort events by:"
                    let rowViewController: PanModalPresentable.LayoutType = eventCategoryFilter
                unself.presentPanModal(rowViewController)
            }
        }
    }
    
    func willDisplay(_ indexPath: IndexPath) {
        let totalSection = tableView.numberOfSections
        if isMyEvents == true {
            guard totalSection > (eventCategory.count) else { return }
            if isNextPageEvent == true, totalSection == indexPath.section, indexPath.row == 0 {
                getEventList()
            }
            if isNextPageMyEvent == true && indexPath.section == 0 && indexPath.row == eventList.count - 1 {
                getMyEventList(sortBy: eventFilterType)
            }
            
        } else {
            guard totalSection > 0 else { return }
            if isNextPageEvent == true, totalSection - 1 == indexPath.section, indexPath.row == 0 {
                getEventList()
            }
        }
    }
    
    func showNoEventScreen() {
        if eventList.count == 0 && eventCategory.count == 0 {
            self.noEventsView.isHidden = false
        } else {
            self.noEventsView.isHidden = true
        }
    }
}

extension EventListViewController: EventCategoryFilterDelegate {
    func selectedIndex(_ type: String, _ selectedIndex: IndexPath) {
        Utils.saveDataToUserDefault(type, UserDefaultKey.myUpcomingFilter)
        eventFilterType = type == "All Upcoming" ? .myUpcoming : .managedFirst
        eventList.removeAll()
        myEventPageNo = 1
        isNextPageMyEvent = false
        getMyEventList(sortBy: eventFilterType)
    }
    
    /*func selectedIndex(_ name: String) {
        Utils.saveDataToUserDefault(name, UserDefaultKey.myUpcomingFilter)
        eventFilterType = name == "All Upcoming" ? .myUpcoming : .managedFirst
        myEventPageNo = 1
        getMyEventList(sortBy: eventFilterType)
    }*/
}

// MARK: - Services
extension EventListViewController {
    func getEventList() {
        let param = [Keys.pageNo: pageNo] as [String: Any]
        
        ServiceManager.shared.fetchEventCategoryWithEventList(params: param) { [weak self] (value, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let category = value {
                if value?.count == 0 {
                        unsafe.isNextPageEvent = false
                        if unsafe.pageNo == 1 {
                            unsafe.eventCategory.removeAll()
                        }
                    } else {
                        if unsafe.pageNo == 1 {
                            unsafe.eventCategory = category
                        } else {
                            unsafe.eventCategory.append(contentsOf: category)
                        }
                        unsafe.pageNo += 1
                        unsafe.isNextPageEvent = true
                    }
                    unsafe.tableView.reloadData()
                } else {
                    Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
                }
            unsafe.tableView.reloadData()
            unsafe.showNoEventScreen()
            
        }
    }
    
    func getMyEventList(sortBy: GetEventType) {
        if isApiCalling == true {
            return
        }
            let param = [Keys.profileUserId: Authorization.shared.profile?.userId ?? "",
                         Keys.search: searchText,
                        // Keys.sortBy: sortBy.rawValue,
                         Keys.pageNo: myEventPageNo] as [String: Any]
            isApiCalling = true
            ServiceManager.shared.fetchEventList(sortBy: sortBy.rawValue, params: param) { [weak self] (value, _, errorMsg) in
                Utils.hideSpinner()
                guard let unsafe = self else { return }
                unsafe.isApiCalling = false
                if let events = value {
                    if value?.count == 0 {
                        unsafe.isNextPageMyEvent = false
                        if unsafe.myEventPageNo == 1 {
                            unsafe.eventList.removeAll()
                        }
                    } else {
                        if unsafe.myEventPageNo == 1 {
                            unsafe.eventList = events
                        } else {
                            unsafe.eventList.append(contentsOf: events)
                        }
                        unsafe.myEventPageNo += 1
                        unsafe.isNextPageMyEvent = true
                    }
                    unsafe.isMyEvents = unsafe.eventList.count > 0 ? true : false
                    unsafe.tableView.reloadData()
                    if unsafe.isFirstTime == false {
                        unsafe.isFirstTime = true
                        unsafe.pageNo = 1
                        unsafe.getEventList()
                    }
                } else {
                    unsafe.pageNo = 1
                    unsafe.getEventList()
                    Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
                }
                unsafe.showNoEventScreen()
            }
        }
    
    func joinEvent(eventId: String, action: String) {
        Utils.showSpinner()
        ServiceManager.shared.joinEvent(eventId: eventId, action: action, params: [:]) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            if data != nil {
                /*
                /// Comment due to task https://www.wrike.com/open.htm?id=411254195
                 if let object = data {
                let isFirstTime = object[Keys.isFirstJoin] as? Int ?? 0
                if isFirstTime == 1 {
                   self?.showJoinAlert()
                } */
                DispatchQueue.main.async {
                    //self?.loadAllData()
                }
            } else if let message = errorMessage {
                self?.showMessage(message: message)
                Utils.hideSpinner()
            }
        }
    }
}
