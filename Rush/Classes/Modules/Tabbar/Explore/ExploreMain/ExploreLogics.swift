//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

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
            return dataList.count
        } else {
            if section == 0 {
                return 3
            } else {
                return 1
            }
        }
    }
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        cell.setup(.none, nil, nil)
        if indexPath.section == 1 {
            cell.setup(.upcoming, nil, nil)
        } else if indexPath.section == 2 {
            cell.setup(.clubs, nil, nil)
        } else if indexPath.section == 3 {
            cell.setup(.classes, nil, nil)
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
    }
    
    func fillEventCell(_ cell: SearchClubCell, _ indexPath: IndexPath) {
        if let data = dataList[indexPath.row] as? EventCategory {
            cell.setup(title: data.name)
        } else if let data = dataList[indexPath.row] as? ClubCategory {
            cell.setup(title: data.name)
        }
        cell.setup(isHideTopSeparator: true)
    }
    
    func fillPeopleCell(_ cell: PeopleCell, _ indexPath: IndexPath) {
        if let people = dataList[indexPath.row] as? Friend {
            cell.setup(title: people.user?.name ?? "")
        }
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        if section == 1 {
            header.setup(title: Text.todayEvent)
        } else if section == 2 {
            header.setup(title: Text.clubsMightLike)
        } else if section == 3 {
            header.setup(title: Text.classesYouMightLike)
        }
        
        header.detailButtonClickEvent = { () in
            // Open other user profile UI for test
            
            Utils.notReadyAlert()
            /*
             if section == 2 {
             self_.performSegue(withIdentifier: Segues.clubListSegue , sender: ClubListType.club)
             } else if section == 3 {
             self_.performSegue(withIdentifier: Segues.clubListSegue , sender: ClubListType.classes)
             }
             */
        }
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        if isSearch && searchType == .event {
            performSegue(withIdentifier: Segues.eventCategorySegue, sender: dataList[indexPath.row])
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
        let param = [Keys.search: searchText] as [String: Any]
        ServiceManager.shared.fetchEventCategoryList(params: param) { [weak self] (data, _) in
            //Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let category = data {
                unsafe.dataList = category
            }
            unsafe.tableView.reloadData()
        }
    }
    
    func getClubCategoryListAPI() {
        //Utils.showSpinner()
        let param = [Keys.search: searchText] as [String: Any]
        ServiceManager.shared.fetchClubCategoryList(params: param) { [weak self] (data, _) in
            //Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let value = data?[Keys.list] as? [[String: Any]] {
                do {
                    let dataClub = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    if let value = try? decoder.decode([ClubCategory].self, from: dataClub) {
                        unsafe.dataList = value
                    }
                    unsafe.tableView.reloadData()
                } catch {
                    
                }
            }
        }
    }
    
    func getFriendListAPI() {
        
        if pageNo == 1 { dataList.removeAll() }
        
        var params = [Keys.pageNo: "\(pageNo)"]
        params[Keys.search] = searchText
        params[Keys.profileUserId] = Authorization.shared.profile?.userId
        
        ServiceManager.shared.fetchFriendsList(params: params) { [weak self] (data, _) in
            guard let unsafe = self else { return }
            Utils.hideSpinner()
            
            if unsafe.pageNo == 1 {
                unsafe.dataList.removeAll()
            }
            
            if let list = data {
                if list.count > 0 {
                    if unsafe.pageNo == 1 {
                        unsafe.dataList = list
                    } else {
                        unsafe.dataList.append(contentsOf: list)
                    }
                    unsafe.pageNo += 1
                    unsafe.isNextPageExist = true
                } else {
                    unsafe.isNextPageExist = false
                    if unsafe.pageNo == 1 {
                        unsafe.dataList.removeAll()
                    }
                }
            }
            unsafe.tableView.reloadData()
        }
    }
}
