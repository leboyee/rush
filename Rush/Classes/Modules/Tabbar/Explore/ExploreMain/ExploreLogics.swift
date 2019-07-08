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
            return (searchType == .event || searchType == .people) ? eventList.count : 1
        } else {
            if section == 0 {
                return 3
            } else {
                return 1
            }
        }
    }
    
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
            cell.setup(.none, nil)
        if indexPath.section == 1 {
            cell.setup(.upcoming, nil)
        } else if indexPath.section == 2 {
            cell.setup(.clubs, nil)
        } else if indexPath.section == 3 {
            cell.setup(.classes, nil)
        }
    }
    
    func fillExploreCell(_ cell: ExploreCell, _ indexPath: IndexPath) {
        let title = indexPath.row == 0 ? Text.events : indexPath.row == 1 ? Text.clubs : indexPath.row == 2 ? Text.classes : ""
        cell.setup(title: title)
        
        let detail = indexPath.row == 0 ? "Find events based on your \ninterests" : indexPath.row == 1 ? "Share your interests with \npeople" : indexPath.row == 2 ? "Keep track of your \nacademics" : ""
        cell.setup(detail: detail)
    }
    
    func fillEventCell(_ cell: SearchClubCell, _ indexPath: IndexPath) {
        cell.setup(title: eventList[indexPath.row])
        cell.setup(isHideTopSeparator: true)
    }
    
    func fillPeopleCell(_ cell: PeopleCell, _ indexPath: IndexPath) {
        cell.setup(title: "John Lotter")
    }
    
    func fillTextHeader(_ header: TextHeader,_ section: Int) {
        if section == 1 {
            header.setup(title: Text.todayEvent)
        } else if section == 2 {
            header.setup(title: Text.clubsMightLike)
        } else if section == 3 {
            header.setup(title: Text.classesYouMightLike)
        }
        
        header.detailButtonClickEvent = { [weak self] () in
            guard let _ = self else { return }
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
}
