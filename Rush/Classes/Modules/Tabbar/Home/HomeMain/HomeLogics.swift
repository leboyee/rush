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
        return section == 0 ? CGFloat.leastNormalMagnitude : 50
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 8
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return isShowTutorial ? UITableView.automaticDimension : CGFloat.leastNormalMagnitude
        } else if indexPath.section == 1 && isShowJoinEvents {
            return UITableView.automaticDimension
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
        if indexPath.section == 1 {
            cell.setup(.upcoming, nil)
        } else if indexPath.section == 2 {
            cell.setup(isShowJoinEvents ? .clubsJoined : .clubs, nil)
        } else {
            cell.setup(.classes, nil)
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
    func getMyClubListAPI(sortBy: String) {
        
        let param = [Keys.profileUserId: Authorization.shared.profile?.userId ?? "0",
                     Keys.search: searchText,
                     Keys.sortBy: sortBy,
                     Keys.pageNo: pageNo] as [String: Any]
        
        Utils.showSpinner()
        ServiceManager.shared.fetchClubList(sortBy: sortBy, params: param) { (data, errorMessage) in
            Utils.hideSpinner()
            if data != nil {
                
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
