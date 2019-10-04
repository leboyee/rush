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
        } else if section == 1 {
            return eventList.count > 0 ? 50 : CGFloat.leastNormalMagnitude
        } else if section == 2 {
            return clubList.count > 0 ? 50 : CGFloat.leastNormalMagnitude
        } else if section == 3 {
            return  classList.count > 0 ? 50 : CGFloat.leastNormalMagnitude
        }
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
            return eventList.count > 0 ? 157 : CGFloat.leastNormalMagnitude
        } else if indexPath.section == 2 {
            return clubList.count > 0 ? 157 : CGFloat.leastNormalMagnitude
        } else if indexPath.section == 3 {
            return classList.count > 0 ? 157 : CGFloat.leastNormalMagnitude
        } else {
            return 157
        }
    }
    
    func cellCount(_ section: Int) -> Int {
        if isShowJoinEvents && section == 1 {
            return 4
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
                unself.isShowTutorial = false
                unself.tableView.reloadData()
            }
        }
    }
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        
        // (type, images, data)
        if indexPath.section == 1 {
            cell.setup(.upcoming, nil, eventList)
        } else if indexPath.section == 2 {
            cell.setup(isShowJoinEvents ? .clubsJoined : .clubs, nil, clubList)
        } else {
            cell.setup(.classes, nil, classList)
        }
        
        cell.cellSelected = { [weak self] (type, id, index) in
            guard let unsafe = self else { return }
            if type == .upcoming {
                let event = unsafe.eventList[index]
                unsafe.showEvent(event: event)
            } else if type == .clubs {
                let club = unsafe.clubList[index]
                unsafe.performSegue(withIdentifier: Segues.clubDetailSegue, sender: club)
            } else if type == .classes {
                let classes = unsafe.classList[index]
                unsafe.performSegue(withIdentifier: Segues.classDetailSegue, sender: classes)
            }
        }
        
        cell.joinSelected = { (index) in
            
        }
    }
    
    func fillEventByDateCell(_ cell: EventByDateCell, _ indexPath: IndexPath) {
        
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        if section == 1 {
            header.setup(title: Text.UpcomingEvents)
        } else if section == 2 {
            header.setup(title: Text.clubs)
        } else if section == 3 {
            header.setup(title: Text.classes)
        }
        
        header.detailButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            // Open other user profile UI for test
            
            if section == 2 {
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
    
    func getEventList(sortBy: GetEventType) {
        
        let param = [Keys.profileUserId: Authorization.shared.profile?.userId ?? "",
                     Keys.search: searchText,
                     Keys.sortBy: sortBy.rawValue,
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
