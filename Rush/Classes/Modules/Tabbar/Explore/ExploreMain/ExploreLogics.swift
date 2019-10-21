//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.


import UIKit

extension ExploreViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : 50
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 8
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 157
        }
    }
    
    func cellCount(_ section: Int) -> Int {
        if isSearch {
            
            if searchType == .event {
                return eventInterestList.count
            } else if searchType == .club {
                return clubInterestList.count
            } else if searchType == .classes {
                return classCategoryList.count
            } else if searchType == .people {
                return peopleList.count
            }
            
        } else {
            if section == 0 {
                return 3
            } else {
                return 1
            }
        }
        return 0
    }
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        cell.setup(.none, nil, nil)
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
            if indexPath.section == 1 {
                let event = unsafe.eventList[index]
                unsafe.performSegue(withIdentifier: Segues.eventDetailSegue, sender: event)
            } else if type == .clubs {
                let club = unsafe.clubList[index]
                unsafe.performSegue(withIdentifier: Segues.clubDetailSegue, sender: club)
            } else if type == .classes {
                let classObject = unsafe.classList[index]
                if classObject.myJoinedClass?.count ?? 0 > 0 {
                    //already joined - so dont show groups
                    unsafe.performSegue(withIdentifier: Segues.classDetailSegue, sender: classObject)
                } else {
                    // not joined yet, so show groups
                    let classGroup = classObject.classGroups?[indexPath.row]
                    unsafe.performSegue(withIdentifier: Segues.searchClubSegue, sender: classGroup)
                }
            }
        }
    }
    
    func fillExploreCell(_ cell: ExploreCell, _ indexPath: IndexPath) {
        let title = indexPath.row == 0 ? Text.events : indexPath.row == 1 ? Text.clubs : indexPath.row == 2 ? Text.classes : ""
        cell.setup(title: title)
        
        let sharePeople = "Share your interests with \npeople"
        let findEvent = "Find events based on your \ninterests"
        let keepTrack = "Keep track of your \nacademics"
        let detail = indexPath.row == 0 ? findEvent : indexPath.row == 1 ? sharePeople : indexPath.row == 2 ? keepTrack : ""
        cell.setup(detail: detail)
        var img1: String = ""
        var img2: String = ""
        var img3: String = ""
        
        switch indexPath.row {
            
        case 0:
            if eventList.count > 0 {
                img1 = eventList[0].photoJson /// Need to update that with photo
            }
            if eventList.count > 1 {
                img2 = eventList[1].photoJson  /// Need to update that with photo
            }
            if eventList.count > 2 {
                img3 = eventList[2].photoJson  /// Need to update that with photo
            }
        case 1:
            if clubList.count > 0 {
                img1 = clubList[0].clubPhoto ?? ""
            }
            if clubList.count > 1 {
                img2 = clubList[1].clubPhoto ?? ""
            }
            if clubList.count > 2 {
                img3 = clubList[2].clubPhoto ?? ""
            }
        case 2:
            if classList.count > 0 {
                img1 = classList[0].photo
            }
            if classList.count > 1 {
                img2 = classList[1].photo
            }
            if classList.count > 2 {
                img3 = classList[2].photo
            }
        default:
            break
        }
        cell.setup(img1Url: img1, img2Url: img2, img3Url: img3)
    }
    
    func fillEventCell(_ cell: SearchClubCell, _ indexPath: IndexPath) {
        
        if searchType == .event {
            cell.setup(title: eventInterestList[indexPath.row].name)
        } else if searchType == .club {
            cell.setup(title: clubInterestList[indexPath.row].name)
        } else if searchType == .classes {
            cell.setup(title: classCategoryList[indexPath.row].name)
        }
        cell.setup(isHideTopSeparator: true)
    }
    
    func fillPeopleCell(_ cell: PeopleCell, _ indexPath: IndexPath) {
        let people = peopleList[indexPath.row]
        cell.setup(title: people.name)
        cell.setup(url: people.photo?.urlThumb())
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        if section == 1 {
            header.setup(title: Text.todayEvent)
        } else if section == 2 {
            header.setup(title: Text.clubsMightLike)
        } else if section == 3 {
            header.setup(title: Text.classesYouMightLike)
        }
        
        // MARK: - HeaderArrow Selected
        header.detailButtonClickEvent = { [weak self] in
            // Open other user profile UI for test
            guard let unself = self else { return }
            
            let type = section == 1 ? ScreenType.event : section == 2 ? ScreenType.club : section == 3 ? .classes : .none
            unself.performSegue(withIdentifier: Segues.eventCategorySegue, sender: type)
            
        }
    }
    // MARK: - Category selected
    func cellSelected(_ indexPath: IndexPath) {
        if isSearch && searchType == .event {
            let category = eventInterestList[indexPath.row]
            performSegue(withIdentifier: Segues.eventCategorySegue, sender: category)
        } else if isSearch && searchType == .club {
            let category = clubInterestList[indexPath.row]
            performSegue(withIdentifier: Segues.eventCategorySegue, sender: category)
        } else if isSearch && searchType == .classes {
            let category = classCategoryList[indexPath.row]
            performSegue(withIdentifier: Segues.eventCategorySegue, sender: category)
        } else if isSearch && searchType == .people {
            let category = peopleList[indexPath.row]
            performSegue(withIdentifier: Segues.otherUserProfile, sender: category)
        } else if indexPath.section == 0 && isSearch == false {
            let type = indexPath.row == 0 ? ScreenType.event : indexPath.row == 1 ? ScreenType.club : indexPath.row == 2 ? .classes : .none
            performSegue(withIdentifier: Segues.eventCategorySegue, sender: type)
        }
    }
}

// MARK: - Services
extension ExploreViewController {
    
    func getEventCategoryListAPI() {
        //Utils.showSpinner()
        
        var params = [Keys.pageNo: eventCatPageNo] as [String: Any]
        params[Keys.search] = searchText
        params[Keys.universityId] = selUniversity.universtiyId
                      
        ServiceManager.shared.fetchEventCategoryList(params: params) { [weak self] (data, _) in
            //Utils.hideSpinner()
            guard let unsafe = self else { return }
            if unsafe.eventCatPageNo == 1 {
                unsafe.eventInterestList.removeAll()
            }
            if let category = data {
                if category.count > 0 {
                    if unsafe.eventCatPageNo == 1 {
                        unsafe.eventInterestList = category
                    } else {
                        unsafe.eventInterestList.append(contentsOf: category)
                    }
                    unsafe.eventCatPageNo += 1
                    unsafe.isEventCatIsNextPageExist = true
                } else {
                    unsafe.isEventCatIsNextPageExist = false
                    if unsafe.eventCatPageNo == 1 {
                        unsafe.eventInterestList.removeAll()
                    }
                }
            }
            
            unsafe.tableView.reloadData()
        }
    }
    
    func getClubCategoryListAPI() {
        //Utils.showSpinner()
        var params = [Keys.pageNo: clubCatPageNo] as [String: Any]
        params[Keys.search] = searchText
        params[Keys.universityId] = selUniversity.universtiyId
        ServiceManager.shared.fetchClubCategoryList(params: params) { [weak self] (data, _) in
            //Utils.hideSpinner()
            guard let unsafe = self else { return }
            if unsafe.clubCatPageNo == 1 {
                unsafe.clubInterestList.removeAll()
            }
            if let category = data {
                if category.count > 0 {
                    if unsafe.clubCatPageNo == 1 {
                        unsafe.clubInterestList = category
                    } else {
                        unsafe.clubInterestList.append(contentsOf: category)
                    }
                    unsafe.clubCatPageNo += 1
                    unsafe.isClubCatIsNextPageExist = true
                } else {
                    unsafe.isClubCatIsNextPageExist = false
                    if unsafe.clubCatPageNo == 1 {
                        unsafe.clubInterestList.removeAll()
                    }
                }
            }
            unsafe.tableView.reloadData()
        }
    }
    
    func getPeopleListAPI() {
        
        if pageNo == 1 { peopleList.removeAll() }
        
        var params = [Keys.pageNo: pageNo] as [String: Any]
        params[Keys.search] = searchText
        params[Keys.profileUserId] = Authorization.shared.profile?.userId
        params[Keys.universityId] = selUniversity.universtiyId
              
        ServiceManager.shared.fetchPeopleList(params: params) { [weak self] (data, _) in
            guard let unsafe = self else { return }
            Utils.hideSpinner()
            
            if unsafe.pageNo == 1 {
                unsafe.peopleList.removeAll()
            }
            
            if let list = data {
                if list.count > 0 {
                    if unsafe.pageNo == 1 {
                        unsafe.peopleList = list
                    } else {
                        unsafe.peopleList.append(contentsOf: list)
                    }
                    unsafe.pageNo += 1
                    unsafe.isNextPageExist = true
                } else {
                    unsafe.isNextPageExist = false
                    if unsafe.pageNo == 1 {
                        unsafe.peopleList.removeAll()
                    }
                }
            }
            unsafe.tableView.reloadData()
        }
    }
    func getClubListAPI(sortBy: String) {
        
        var param = [Keys.search: searchText,
                     Keys.sortBy: sortBy,
                     Keys.pageNo: 1] as [String: Any]
        param[Keys.universityId] = selUniversity.universtiyId
              
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
        //to get today's events
        let dateFormat = "yyyy:MM:dd" // Date format
        let startDate = Date().localToUTC(date: Date().toDate(format: dateFormat) + " " + "00:00:00", toForamte: serverDateFormate, getFormate: serverDateFormate)
        let endDate = Date().localToUTC(date: Date().toDate(format: dateFormat) + " " + "23:59:59", toForamte: serverDateFormate, getFormate: serverDateFormate)
        
        var param = [Keys.profileUserId: Authorization.shared.profile?.userId ?? "",
                     Keys.search: searchText,
                     Keys.sortBy: sortBy.rawValue,
                     Keys.fromStart: startDate,
                     Keys.toStart: endDate,
                     Keys.pageNo: 1] as [String: Any]
        param[Keys.universityId] = selUniversity.universtiyId
              
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
    
    func getClassListAPI() {
        var param = [Keys.pageNo: "1"] as [String: Any]
        param[Keys.universityId] = selUniversity.universtiyId
              
        ServiceManager.shared.fetchClassList(params: param) { [weak self] (data, errorMsg) in
            guard let unsafe = self else { return }
            if let classes = data {
                unsafe.classList = classes
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    func getClassCategoryAPI() {
        var param = [Keys.pageNo: classCatPageNo] as [String: Any]
        param[Keys.universityId] = selUniversity.universtiyId
              
        ServiceManager.shared.fetchCategoryClassList(params: param) { [weak self] (data, _) in
            //Utils.hideSpinner()
            guard let unsafe = self else { return }
            if unsafe.classCatPageNo == 1 {
                unsafe.classCategoryList.removeAll()
            }
            if let category = data {
                if category.count > 0 {
                    if unsafe.classCatPageNo == 1 {
                        unsafe.classCategoryList = category
                    } else {
                        unsafe.classCategoryList.append(contentsOf: category)
                    }
                    unsafe.classCatPageNo += 1
                    unsafe.isClassCatIsNextPageExist = true
                } else {
                    unsafe.isClassCatIsNextPageExist = false
                    if unsafe.classCatPageNo == 1 {
                        unsafe.classCategoryList.removeAll()
                    }
                }
            }
            unsafe.tableView.reloadData()
        }
    }
}
