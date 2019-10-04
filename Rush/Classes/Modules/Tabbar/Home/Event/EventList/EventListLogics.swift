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
        cell.setup(.none, nil, eventList)
        // (type, images, data)
    }
    
    func fillEventByDateCell(_ cell: EventByDateCell, _ indexPath: IndexPath) {
        let event = eventList[indexPath.row]
        cell.setup(cornerRadius: 24)
        cell.setup(isHideSeparator: false)
        cell.setup(title: event.title)
        cell.setup(date: event.start)
        cell.setup(start: event.start, end: event.end)
        cell.setup(eventImageUrl: event.photoJson.photo?.urlThumb())
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
            categoryName = eventCategoryObject.name
            header.setup(detailArrowImage: UIImage(named: "red-arrow") ?? UIImage())
        }
        header.setup(title: categoryName)
        header.detailButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            if unself.isMyEvents == true && section == 0 {
                guard let eventCategoryFilter = UIStoryboard(name: "Event", bundle: nil).instantiateViewController(withIdentifier: "EventCateogryFilterViewController") as? EventCateogryFilterViewController & PanModalPresentable else { return }
                    eventCategoryFilter.dataArray = Utils.myUpcomingFileter()
                    eventCategoryFilter.delegate = self
                let filter = Utils.getDataFromUserDefault(UserDefaultKey.myUpcomingFilter) as? String
                eventCategoryFilter.selectedIndex = filter == "All Upcoming" ? 0 : 1
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
            if isNextPageMyEvent == true && indexPath.row == eventList.count - 1 {
                let filter = Utils.getDataFromUserDefault(UserDefaultKey.myUpcomingFilter) as? String
                      getMyEventList(sortBy: filter?.isEmpty == true ? .upcoming : filter == "All Upcoming" ? .upcoming : .myUpcoming )
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
    func selectedIndex(_ name: String) {
        Utils.saveDataToUserDefault(name, UserDefaultKey.myUpcomingFilter)
        myEventPageNo = 1
        getMyEventList(sortBy: name == "All Upcoming" ? .upcoming : .myUpcoming )
    }
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
            unsafe.showNoEventScreen()
            }
    }
    
    func getMyEventList(sortBy: GetEventType) {
            
            let param = [Keys.profileUserId: Authorization.shared.profile?.userId ?? "",
                         Keys.search: searchText,
                         Keys.sortBy: sortBy.rawValue,
                         Keys.pageNo: myEventPageNo] as [String: Any]
            
            ServiceManager.shared.fetchEventList(sortBy: sortBy.rawValue, params: param) { [weak self] (value, errorMsg) in
                Utils.hideSpinner()
                guard let unsafe = self else { return }
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
                } else {
                    Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
                }
                unsafe.showNoEventScreen()
            }
        }
}
