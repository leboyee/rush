//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension HomeViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        } /*else if section == 1 {
            return eventList.count > 0 ? 50 : CGFloat.leastNormalMagnitude
        } else if section == 2 {
            return clubList.count > 0 ? 50 : CGFloat.leastNormalMagnitude
        } else if section == 3 {
            return  classList.count > 0 ? 50 : CGFloat.leastNormalMagnitude
        }*/
        return 50
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 8
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return isShowTutorial ? UITableView.automaticDimension : CGFloat.leastNormalMagnitude
        } else if indexPath.section == 1 && isShowJoinEvents {
            return UITableView.automaticDimension
        } else if indexPath.section == 1 {
            return eventList.count > 0 ? 157 : UITableView.automaticDimension
        } else if indexPath.section == 2 {
            return clubList.count > 0 ? 157 : UITableView.automaticDimension
        } else if indexPath.section == 3 {
            return classList.count > 0 ? 157 : UITableView.automaticDimension
        } else {
            return 157
        }
    }
    
    func isShowEmptyPlaceholder(_ section: Int) -> Bool {
        if (section == 1 && eventList.count == 0) || (section == 2 && clubList.count == 0) || (section == 3 && classList.count == 0) {
            return true
        }
        return false
    }
    
    func cellCount(_ section: Int) -> Int {
        if isShowJoinEvents && section == 1 {
            return eventList.count
        } else {
            return 1
        }
    }
    
    func fillTutorialCell(_ cell: TutorialPopUpCell) {
        
        cell.setup(text: Message.joinEventsAndClassses)
        cell.setup(bgImage: "popup-green-left")
        cell.setup(buttonTitle: "OK")
        
        cell.okButtonClickEvent = { [weak self] (text) in
            guard let unself = self else { return }
            if text == "OK" {
                cell.setup(text: Text.createEventAndOpenClub)
                cell.setup(bgImage: "popup-green-right")
                cell.setup(buttonTitle: "Nice!")
            } else {
                Utils.removeDataFromUserDefault(kHomeTutorialKey)
                unself.isShowTutorial = false
                unself.tableView.reloadData()
            }
        }
    }
    
    func fillPlaceholderCell(_ cell: NoEventsCell, _ section: Int) {
        if section == 1 {
            if isShowJoinEvents == false && eventList.count == 0 {
                cell.setUpcomingEvents()
            } else {
                cell.setEvents()
            }
        } else if section == 2 {
            cell.setClub()
        } else if section == 3 {
            cell.setClasses()
        }
    }
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        
        // (type, images, data)
        if indexPath.section == 1 {
            cell.setup(.upcoming, nil, eventList)
        } else if indexPath.section == 2 {
            cell.setup(.clubs, nil, clubList)
        } else if indexPath.section == 3 {
            cell.setup(.classes, nil, classList)
        }
        
        // MARK: - CollectionItem Selected
        cell.cellSelected = { [weak self] (type, id, index) in
            guard let unsafe = self else { return }
            if type == .upcoming {
                let event = unsafe.eventList[index]
                unsafe.showEvent(event: event)
            } else if type == .clubs {
                let club = unsafe.clubList[index]
                unsafe.performSegue(withIdentifier: Segues.clubDetailSegue, sender: club)
            } else if type == .clubsJoined {
                let club = unsafe.clubList[index]
                unsafe.performSegue(withIdentifier: Segues.clubDetailSegue, sender: club)
            } else if type == .classes {
                let classObject = unsafe.classList[index]
                if classObject.myJoinedClass?.count ?? 0 > 0 {
                    //already joined - so dont show groups
                    unsafe.performSegue(withIdentifier: Segues.classDetailSegue, sender: classObject)
                } else {
                    // not joined yet, so show groups
                    unsafe.performSegue(withIdentifier: Segues.searchClubSegue, sender: classObject)
                }
            }
        }
        
        cell.joinSelected = { (index) in
            
        }
    }
    
    func fillEventByDateCell(_ cell: EventByDateCell, _ indexPath: IndexPath) {
        let event = eventList[indexPath.row]
        cell.setup(title: event.title)
        cell.setup(eventImageUrl: event.photo?.urlThumb())
        cell.setup(start: event.start, end: event.end)
        cell.setup(date: event.start)
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        if section == 1 {
            if isShowJoinEvents == false && eventList.count == 0 {
                header.setup(title: Text.UpcomingEvents)
            } else {
                header.setup(title: Text.events)
            }
        } else if section == 2 {
            header.setup(title: Text.clubs)
        } else if section == 3 {
            header.setup(title: Text.classes)
        }
        
        // MARK: - HeaderArrow Selected
        header.detailButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            // Open other user profile UI for test
            if section == 1 {
                unself.performSegue(withIdentifier: Segues.eventListSeuge, sender: unself.eventList)
            } else if section == 2 {
                unself.performSegue(withIdentifier: Segues.clubListSegue, sender: ClubListType.club)
            } else if section == 3 {
                unself.performSegue(withIdentifier: Segues.clubListSegue, sender: ClubListType.classes)
            } else {
                
            }
        }
    }
}

// MARK: - Services
extension HomeViewController {
    func getHomeList() {
        ServiceManager.shared.fetchHomeList(params: [:]) { [weak self] (data, _) in
            guard let unsafe = self else { return }
            if let home = data {
                if home.myEvents?.count ?? 0 > 0 {
                    unsafe.isShowJoinEvents = true
                    unsafe.eventList = home.myEvents ?? [Event]()
                } else {
                    unsafe.isShowJoinEvents = false
                    unsafe.eventList = home.interestedEvents ?? [Event]()
                }
                unsafe.clubList = home.interestedClubList ?? [Club]()
                unsafe.classList = home.classList ?? [SubClass]()
            }
            unsafe.tableView.reloadData()
        }
    }
    
    func getEventList(sortBy: GetEventType) {
        
        let param = [Keys.profileUserId: Authorization.shared.profile?.userId ?? "",
                     Keys.search: searchText,
                     Keys.sortBy: sortBy.rawValue,
                     Keys.pageNo: pageNo] as [String: Any]
        
        ServiceManager.shared.fetchEventList(sortBy: sortBy.rawValue, params: param) { [weak self] (value, _, _) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let events = value {
                unsafe.eventList = events
            }
            if unsafe.eventList.count > 0 {
                unsafe.isShowJoinEvents = true
                unsafe.tableView.reloadData()
            } else {
                unsafe.isShowJoinEvents = false
                if sortBy != .interestedFeed {
                    unsafe.getEventList(sortBy: .interestedFeed)
                }
            }
            unsafe.getClubListAPI(sortBy: "feed")
            
        }
    }
    
    func getClubListAPI(sortBy: String) {
        
        let param = [Keys.search: searchText,
                     Keys.sortBy: sortBy,
                     Keys.pageNo: pageNo] as [String: Any]
        
        if clubList.count == 0 {
            Utils.showSpinner()
        }
        
        ServiceManager.shared.fetchClubList(sortBy: sortBy, params: param) { [weak self] (value, _, _) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let clubs = value {
                unsafe.clubList = clubs
            }
            unsafe.tableView.reloadData()
            unsafe.getClassListAPI()
        }
    }
    
    /*  func getClassCategoryAPI() {
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
     }*/
    func getClassListAPI() {
        let param = [Keys.pageNo: pageNo] as [String: Any]
        
        ServiceManager.shared.fetchClassList(params: param) { [weak self] (data, _) in
            guard let unsafe = self else { return }
            if let classes = data {
                unsafe.classList = classes
            }
            unsafe.tableView.reloadData()
        }
    }
}
