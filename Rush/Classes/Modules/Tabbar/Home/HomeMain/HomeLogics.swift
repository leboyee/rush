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
        } else if section == 2 {
            return clubList.count > 0 ? 50 : CGFloat.leastNormalMagnitude
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
        } else if indexPath.section == 2 {
            return clubList.count > 0 ? 157 : CGFloat.leastNormalMagnitude
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
            cell.setup(.upcoming, nil, nil)
        } else if indexPath.section == 2 {
            cell.setup(isShowJoinEvents ? .clubsJoined : .clubs, nil, clubList)
        } else {
            cell.setup(.classes, nil, nil)
        }
        
        cell.cellSelected = { [weak self] (type, id, index) in
            guard let unsafe = self else { return }
            if type == .upcoming {
                unsafe.showEvent()
            } else if type == .clubs {
                let club = unsafe.clubList[index]
                unsafe.performSegue(withIdentifier: Segues.clubDetailSegue, sender: club)
            }
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
                unself.performSegue(withIdentifier: Segues.createPost, sender: nil)
            }
        }
    }
}

// MARK: - Services
extension HomeViewController {
    func getClubListAPI(sortBy: String) {
        clubList.removeAll()
        let param = [Keys.search: searchText,
                     Keys.sortBy: sortBy,
                     Keys.pageNo: pageNo] as [String: Any]
        
        Utils.showSpinner()
        ServiceManager.shared.fetchClubList(sortBy: sortBy, params: param) { [weak self] (value, errorMsg) in
            Utils.hideSpinner()
            guard let unowned = self else { return }
            if let clubs = value {
                unowned.clubList = clubs
                unowned.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func getEventList(sortBy: String) {
        
        let param = [Keys.profileUserId: Authorization.shared.profile?.userId ?? "",
                     Keys.search: searchText,
                     Keys.sortBy: sortBy,
                     Keys.pageNo: pageNo] as [String: Any]
        
        ServiceManager.shared.fetchEventList(sortBy: sortBy, params: param) { [weak self] (value, errorMsg) in
            Utils.hideSpinner()
            guard let unowned = self else { return }
//            if let value = list[Keys.data] as? [String: Any] {
//                if let club = value[Keys.club] as? [String: Any] {
//                    do {
//                        let dataClub = try JSONSerialization.data(withJSONObject: club, options: .prettyPrinted)
//                        let decoder = JSONDecoder()
//                        let value = try decoder.decode(Club.self, from: dataClub)
//                        uwself.clubInfo = value
//                    } catch {
//
//                    }
//                }
//            }
        }
    }
}
