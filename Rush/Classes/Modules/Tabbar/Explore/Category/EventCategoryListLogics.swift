//
//  FriendsListLogics.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import PanModal

enum EventCategoryDayFilter: Int {
    case none = 0
    case today = 1
    case tomorrow = 2
    case thisWeek = 3
    case thisWeekend = 4
    case nextWeek = 5
    
}

enum EventCategoryTimeFilter: Int {
    case allTime = 0
    case morning = 1
    case day = 2
    case evening = 3
}

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
            title = indexPath.item == 0 ? firstSortText : indexPath.item == 1 ? secondSortText : thirdSortText
        } else if type == .club {
            title = indexPath.item == 0 ? firstSortText : indexPath.item == 1 ? secondSortText : thirdSortText
        } else if type == .classes {
            title = indexPath.item == 0 ? firstSortText : indexPath.item == 1 ? secondSortText : thirdSortText
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
        isFirstFilter = false
        isSecondFilter = false
        isThirdFilter = false
        
        if indexPath.item == 0 {
            isFirstFilter = true
        } else if indexPath.item == 1 {
            isSecondFilter = true
        } else if indexPath.item == 2 {
            isThirdFilter = true
        }
        
        if type == .event {
            
            guard let eventCategoryFilter = UIStoryboard(name: "Event", bundle: nil).instantiateViewController(withIdentifier: "EventCateogryFilterViewController") as? EventCateogryFilterViewController & PanModalPresentable else { return }
            eventCategoryFilter.dataArray = indexPath.item == 0 ? Utils.upcomingFiler() : indexPath.item == 1 ? Utils.anyTimeFilter() : Utils.friendsFilter()
            eventCategoryFilter.delegate = self
            eventCategoryFilter.isFromExplore = true
            eventCategoryFilter.selectedIndex = indexPath.item == 0 ? firstFilterIndex : indexPath.item == 1 ? secondFilterIndex : thirdFilterIndex
            let rowViewController: PanModalPresentable.LayoutType = eventCategoryFilter
            presentPanModal(rowViewController)
            collectionView.reloadData()
        } else if type == .club {
            guard let eventCategoryFilter = UIStoryboard(name: "Event", bundle: nil).instantiateViewController(withIdentifier: "EventCateogryFilterViewController") as? EventCateogryFilterViewController & PanModalPresentable else { return }
            //Show all categories for the screen.
            eventCategoryFilter.delegate = self
            eventCategoryFilter.isFromExplore = true
            if clubCategoryList.count > 0 {
                let cat = clubCategoryList.compactMap({ $0.interestName })
                eventCategoryFilter.dataArray = indexPath.item == 0 ? cat : indexPath.item == 1 ? Utils.popularFilter() : Utils.peopleFilter()
                eventCategoryFilter.delegate = self
                eventCategoryFilter.selectedIndex = indexPath.item == 0 ? firstFilterIndex : indexPath.item == 1 ? secondFilterIndex : thirdFilterIndex
                
            } else if interestList.count > 0 {
                let cat = interestList.compactMap({ $0.interestName })
                eventCategoryFilter.dataArray = indexPath.item == 0 ? cat : indexPath.item == 1 ? Utils.popularFilter() : Utils.peopleFilter()
                eventCategoryFilter.delegate = self
                eventCategoryFilter.selectedIndex = indexPath.item == 0 ? firstFilterIndex : indexPath.item == 1 ? secondFilterIndex : thirdFilterIndex
                
            }
            
            let rowViewController: PanModalPresentable.LayoutType = eventCategoryFilter
            presentPanModal(rowViewController)
            collectionView.reloadData()
        } else if type == .classes {
            guard let eventCategoryFilter = UIStoryboard(name: "Event", bundle: nil).instantiateViewController(withIdentifier: "EventCateogryFilterViewController") as? EventCateogryFilterViewController & PanModalPresentable else { return }
            //Show all categories for the screen.
            eventCategoryFilter.delegate = self
            eventCategoryFilter.isFromExplore = true
            let cat = classCategoryList.compactMap({ $0.name })
            eventCategoryFilter.dataArray = indexPath.item == 0 ? cat : indexPath.item == 1 ? Utils.popularFilter() : Utils.peopleFilter()
            eventCategoryFilter.selectedIndex = indexPath.item == 0 ? firstFilterIndex : indexPath.item == 1 ? secondFilterIndex : thirdFilterIndex
            
            let rowViewController: PanModalPresentable.LayoutType = eventCategoryFilter
            presentPanModal(rowViewController)
            collectionView.reloadData()
        }
        
    }
    
    func fillClubCell(_ cell: FriendClubCell, _ indexPath: IndexPath) {
        if type == .club {
            guard clubList.count > indexPath.row else { return }
            let club = clubList[indexPath.row]
            cell.setup(title: club.clubName ?? "")
            cell.setup(detail: club.clubDesc ?? "")
            cell.setup(invitee: club.invitees)
            cell.setup(clubImageUrl: club.photo?.urlThumb())
            if club.clubTotalJoined > 3 {
                cell.setup(inviteeCount: club.clubTotalJoined - 3)
            } else {
                cell.setup(inviteeCount: 0)
            }
        } else if type == .classes {
            guard classList.count > indexPath.row else { return }
            let myclass = classList[indexPath.row]
            cell.setup(classesImageUrl: myclass.photo?.urlThumb())
            cell.setup(title: myclass.name)
            if myclass.myJoinedClass?.count ?? 0 > 0 {
                let jClass = myclass.myJoinedClass?.first
                let cGroup = myclass.classGroups?.filter({ $0.id == jClass?.groupId }).first
                cell.setup(detail: cGroup?.name ?? "")
                
            } else {
                var countClass = ""
                let count = myclass.classGroups?.count
                if count == 0 {
                    countClass = "No classes"
                } else if count == 1 {
                    countClass = "1 class"
                } else {
                    countClass = "\(count ?? 0) classes"
                }
                cell.setup(detail: countClass)
                // cell.setup(detail: "\(myclass.classGroups?.count ?? 0) Classes")
            }
            
            var rosterArray = [Invitee]()
            for rs in myclass.rosters ?? [ClassJoined]() {
                if let user = rs.user {
                    let inv = Invitee()
                    inv.user = user
                    rosterArray.append(inv)
                }
            }
            cell.setup(invitee: rosterArray)
            if myclass.classTotalRosters > 3 {
                cell.setup(inviteeCount: Int(myclass.classTotalRosters - 3))
            } else {
                cell.setup(inviteeCount: 0)
            }
        } else {
            cell.setup(detail: "SOMM 24-A")
        }
    }
    
    func fillEventCell(_ cell: EventByDateCell, _ indexPath: IndexPath) {
        guard eventList.count > indexPath.row else { return }
        let event = eventList[indexPath.row]
        cell.setup(title: event.title)
        cell.setup(date: event.start)
        cell.setup(start: event.start, end: event.end)
        cell.setup(eventImageUrl: event.photo?.urlThumb())
        
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
        } else if type == .club {
            let club = clubList[indexPath.row]
            performSegue(withIdentifier: Segues.clubDetailSegue, sender: club)
        } else if type == .classes {
            let classObject = classList[indexPath.row]
            if classObject.myJoinedClass?.count ?? 0 > 0 {
                //already joined - so dont show groups
                performSegue(withIdentifier: Segues.classDetailSegue, sender: classObject)
            } else {
                // not joined yet, so show groups
                performSegue(withIdentifier: Segues.searchClubSegue, sender: classObject)
            }
        }
    }
    
    func filterType(eventType: EventCategoryDayFilter) {
        let arrWeekDates = Date().getWeekDates() // Get dates of Current and Next week.
        let dateFormat = "yyyy:MM:dd" // Date format
        let thisMon = arrWeekDates.thisWeek.first!.toDate(format: dateFormat)
        let thisSat = arrWeekDates.thisWeek[arrWeekDates.thisWeek.count - 2].toDate(format: dateFormat)
        let thisSun = arrWeekDates.thisWeek[arrWeekDates.thisWeek.count - 1].toDate(format: dateFormat)
        let nextMon = arrWeekDates.nextWeek.first!.toDate(format: dateFormat)
        _ = arrWeekDates.nextWeek[arrWeekDates.nextWeek.count - 2].toDate(format: dateFormat)
        let nextSun = arrWeekDates.nextWeek[arrWeekDates.nextWeek.count - 1].toDate(format: dateFormat)
        
        eventDayFilter = eventType
        switch eventType {
        case .none:
            do {
                startDate = ""
                endDate = ""
            }
        case .today:
            do {
                startDate = Date().localToUTC(date: Date().toDate(format: dateFormat) + " " + "00:00:00", toForamte: serverDateFormate, getFormate: serverDateFormate)
                endDate = Date().localToUTC(date: Date().toDate(format: dateFormat) + " " + "23:59:59", toForamte: serverDateFormate, getFormate: serverDateFormate)
            }
        case .tomorrow:
            do {
                startDate = Date().localToUTC(date: Date().tomorrow.toDate(format: dateFormat) + " " + "00:00:00", toForamte: serverDateFormate, getFormate: serverDateFormate)
                endDate = Date().localToUTC(date: Date().tomorrow.toDate(format: dateFormat) + " " + "23:59:59", toForamte: serverDateFormate, getFormate: serverDateFormate)
            }
            
        case .thisWeek:
            do {
                
                startDate = Date().localToUTC(date: thisMon + " " + "00:00:00", toForamte: serverDateFormate, getFormate: serverDateFormate)
                endDate = Date().localToUTC(date: thisSun + " " + "23:59:59", toForamte: serverDateFormate, getFormate: serverDateFormate)
            }
        case .thisWeekend:
            do {
                
                startDate = Date().localToUTC(date: thisSat + " " + "00:00:00", toForamte: serverDateFormate, getFormate: serverDateFormate)
                endDate = Date().localToUTC(date: thisSun + " " + "23:59:59", toForamte: serverDateFormate, getFormate: serverDateFormate)
            }
        case .nextWeek:
            do {
                startDate = Date().localToUTC(date: nextMon + " " + "00:00:00", toForamte: serverDateFormate, getFormate: serverDateFormate)
                endDate = Date().localToUTC(date: nextSun + " " + "23:59:59", toForamte: serverDateFormate, getFormate: serverDateFormate)
            }
        }
    }
    
    func filterType(eventType: EventCategoryTimeFilter) {
        let dateFormat = "yyyy:MM:dd" // Date format
        eventTimeFilter = eventType
        switch eventType {
        case .allTime:
            do {
                startTime = ""
                endTime = ""
            }
        case .morning:
            do {
                let startArray = Date().localToUTC(date: Date().toDate(format: dateFormat) + " " + "06:00:00", toForamte: serverDateFormate, getFormate: serverDateFormate).split(separator: " ")
                startTime = String(startArray.last ?? "")
                
                let endArray = Date().localToUTC(date: Date().toDate(format: dateFormat) + " " + "11:59:59", toForamte: serverDateFormate, getFormate: serverDateFormate).split(separator: " ")
                endTime = String(endArray.last ?? "")
            }
        case .day:
            do {
                let startArray = Date().localToUTC(date: Date().toDate(format: dateFormat) + " " + "12:00:00", toForamte: serverDateFormate, getFormate: serverDateFormate).split(separator: " ")
                startTime = String(startArray.last ?? "")
                
                let endArray = Date().localToUTC(date: Date().toDate(format: dateFormat) + " " + "17:59:59", toForamte: serverDateFormate, getFormate: serverDateFormate).split(separator: " ")
                endTime = String(endArray.last ?? "")
            }
        case .evening:
            do {
                let startArray = Date().localToUTC(date: Date().toDate(format: dateFormat) + " " + "18:00:00", toForamte: serverDateFormate, getFormate: serverDateFormate).split(separator: " ")
                startTime = String(startArray.last ?? "")
                
                let endArray = Date().localToUTC(date: Date().toDate(format: dateFormat) + " " + "06:00:00", toForamte: serverDateFormate, getFormate: serverDateFormate).split(separator: " ")
                endTime = String(endArray.last ?? "")
            }
        }
    }
}

// MARK: - EventCategoryFilterDelegate
extension EventCategoryListViewController: EventCategoryFilterDelegate {
    
    func selectedIndex(_ type: String, _ indexPath: IndexPath) {
        
        pageNo = 1
        isNextPage = false
        
        if self.type == .event {
            if isFirstFilter {
                guard let index = Utils.upcomingFiler().firstIndex(where: { $0 == type }) else { return }
                firstFilterIndex = index
                firstSortText = type
                filterType(eventType: EventCategoryDayFilter(rawValue: index) ?? .none)
            } else if isSecondFilter {
                secondSortText = type
                guard let index = Utils.anyTimeFilter().firstIndex(where: { $0 == type }) else { return }
                secondFilterIndex = index
                filterType(eventType: EventCategoryTimeFilter(rawValue: index) ?? .allTime)
                
            } else if isThirdFilter {
                thirdSortText = type
                self.isOnlyFriendGoing = type == "Everyone" ? 0 : 1
                thirdFilterIndex = self.isOnlyFriendGoing
            }
            isFirstFilter = false
            isSecondFilter = false
            isThirdFilter = false
            collectionView.reloadData()
            getEventList(sortBy: .upcoming, eventCategoryId: nil, isShowSpinner: false)
        } else if self.type == .club {
            if isFirstFilter {
                firstFilterIndex = indexPath.row
                firstSortText = type
                if clubCategoryList.count > 0 {
                    interest = clubCategoryList[indexPath.row]
                    
                    if (searchTextField.attributedPlaceholder?.string ?? "") != "Search clubs" {
                        updateTitle(text: interest?.interestName ?? "")
                    }
                } else if interestList.count > 0 {
                    interest = interestList[indexPath.row]
                }
            } else if isSecondFilter {
                secondSortText = type
                secondFilterIndex = indexPath.row
            } else if isThirdFilter {
                thirdSortText = type
                thirdFilterIndex = indexPath.row
            }
            getClubListAPI(sortBy: "feed", clubCategoryId: String(interest?.interestId ?? 0), isShowSpinner: false)
            isFirstFilter = false
            isSecondFilter = false
            isThirdFilter = false
            collectionView.reloadData()
        } else if self.type == .classes {
            if isFirstFilter {
                firstFilterIndex = indexPath.row
                firstSortText = type
                classCategory = classCategoryList[indexPath.row]
            } else if isSecondFilter {
                secondSortText = type
                secondFilterIndex = indexPath.row
            } else if isThirdFilter {
                thirdSortText = type
                thirdFilterIndex = indexPath.row
            }
            getClassListAPI(isShowSpinner: false)
            isFirstFilter = false
            isSecondFilter = false
            isThirdFilter = false
            collectionView.reloadData()
        }
    }
}

// Services
extension EventCategoryListViewController {
    
    func getClubListAPI(sortBy: String, clubCategoryId: String?, isShowSpinner: Bool) {
        
        hasCalledAPI = 1
        
        if isShowSpinner {
            Utils.showSpinner()
        }
        
        let order = secondFilterIndex == 0 ? "popular" : "newest"
        var param = [Keys.search: searchText,
                     Keys.sortBy: sortBy,
                     Keys.intId: interest?.interestId ?? "",
                     Keys.orderBy: order,
                     Keys.isOnlyFriendJoined: thirdFilterIndex,
                     Keys.pageNo: pageNo] as [String: Any]
        param[Keys.universityId] = selUniversity.universtiyId
        
        if isFromHomeScreen {
            param[Keys.universityId] = Authorization.shared.profile?.university?.first?.universtiyId ?? 0
        }
        
        if (interest?.interestId) != nil && (interest?.interestId) !=  0 {
            param[Keys.intId] = interest?.interestId
        }
        
        if pageNo == 1 {
            clubList.removeAll()
        }
        
        ServiceManager.shared.fetchClubList(sortBy: sortBy, params: param) { [weak self] (value, _, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let clubs = value {
                if clubs.count > 0 {
                    if unsafe.pageNo == 1 {
                        unsafe.clubList.removeAll()
                        unsafe.clubList = clubs
                    } else {
                        unsafe.clubList.append(contentsOf: clubs)
                    }
                    unsafe.isNextPage = true
                } else {
                    if unsafe.pageNo == 1 {
                        unsafe.clubList.removeAll()
                    }
                    unsafe.isNextPage = false
                }
                unsafe.tableView.reloadData()
            } else {
                unsafe.isNextPage = false
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
            unsafe.hasCalledAPI = 0
        }
    }
    
    func getEventList(sortBy: GetEventType, eventCategoryId: String?, isShowSpinner: Bool) {
        
        hasCalledAPI = 1
        
        if isShowSpinner {
            Utils.showSpinner()
        }
        
        var param = [Keys.search: searchText,
                     Keys.sortBy: sortBy.rawValue,
                     Keys.pageNo: pageNo,
                     Keys.isOnlyFriendGoing: "\(isOnlyFriendGoing)"] as [String: Any]
        
        if eventCategoryId != "" {
            param[Keys.intId] = eventCategoryId
        }
        
        if (interest?.interestId) != nil && (interest?.interestId) !=  0 {
            param[Keys.intId] = interest?.interestId
        }
        
        if eventDayFilter != .none {
            param[Keys.fromStart] = startDate
            param[Keys.toStart] = endDate
        }
        
        if eventTimeFilter != .allTime {
            param[Keys.fromTime] = startTime
            param[Keys.toTime] = endTime
        }
        
        if selUniversity.universtiyId > 0 {
            param[Keys.universityId] = selUniversity.universtiyId
        } else if tabBarController?.selectedIndex == 0 {
            param[Keys.universityId] = Authorization.shared.profile?.university?.first?.universtiyId ?? 0
        }
        
        if pageNo == 1 {
            eventList.removeAll()
        }
        
        ServiceManager.shared.fetchEventList(sortBy: sortBy.rawValue, params: param) { [weak self] (value, _, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let events = value {
                if events.count > 0 {
                    if unsafe.pageNo == 1 {
                        unsafe.eventList.removeAll()
                        unsafe.eventList = events
                    } else {
                        unsafe.eventList.append(contentsOf: events)
                    }
                    unsafe.isNextPage = true
                } else {
                    if unsafe.pageNo == 1 {
                        unsafe.eventList.removeAll()
                    }
                    unsafe.isNextPage = false
                }
                unsafe.tableView.reloadData()
            } else {
                unsafe.isNextPage = false
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
            unsafe.hasCalledAPI = 0
        }
    }
    
    func getClassListAPI(isShowSpinner: Bool) {
        
        hasCalledAPI = 1
        
        if isShowSpinner {
            Utils.showSpinner()
        }
        
        if pageNo == 1 {
            classList.removeAll()
        }
        
        let order = secondFilterIndex == 0 ? "popular" : "newest"
        var param = [Keys.search: searchText,
                     Keys.sortBy: "explore",
                     Keys.categoryId: classCategory?.id ?? "",
                     Keys.orderBy: order,
                     Keys.isOnlyFriendJoined: thirdFilterIndex,
                     Keys.pageNo: pageNo] as [String: Any]
        param[Keys.universityId] = selUniversity.universtiyId
        
        if isFromHomeScreen {
             param[Keys.universityId] = Authorization.shared.profile?.university?.first?.universtiyId ?? 0
        }
        
        ServiceManager.shared.fetchClassList(params: param) { [weak self] (data, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let classes = data {
                if classes.count > 0 {
                    if unsafe.pageNo == 1 {
                        unsafe.classList.removeAll()
                        unsafe.classList = classes
                    } else {
                        unsafe.classList.append(contentsOf: classes)
                    }
                    unsafe.isNextPage = true
                } else {
                    if unsafe.pageNo == 1 {
                        unsafe.classList.removeAll()
                    }
                    unsafe.isNextPage = false
                }
                unsafe.tableView.reloadData()
            } else {
                unsafe.isNextPage = false
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
            unsafe.hasCalledAPI = 0
        }
    }
    
    func getClassCategoryAPI() {
        let order = secondFilterIndex == 0 ? "popular" : "newest"
        let param = [Keys.search: searchText,
                     Keys.classCatId: classCategory?.id ?? "",
                     Keys.orderBy: order,
                     Keys.isOnlyFriendJoined: thirdFilterIndex,
                     Keys.pageNo: pageNo] as [String: Any]
        
        ServiceManager.shared.fetchCategoryClassList(params: param) { [weak self] (data, errorMsg) in
            guard let unsafe = self else { return }
            if let classes = data {
                unsafe.classCategoryList = classes
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    func getClubCategoryListAPI() {
        //Utils.showSpinner()
        var params = [Keys.pageNo: "1"]
        params[Keys.search] = searchText
        ServiceManager.shared.fetchClubCategoryList(params: params) { [weak self] (data, _) in
            //Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let category = data {
                unsafe.clubCategoryList = category
                unsafe.tableView.reloadData()
            }
        }
    }
}
