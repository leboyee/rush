//
//  EventListLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 13/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

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
        return self.isMyEvents == true && section == 0 ? 5 : 1
    }
        
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        cell.setup(.none, nil, eventList)
        // (type, images, data)
    }
    
    func fillEventByDateCell(_ cell: EventByDateCell, _ indexPath: IndexPath) {
        cell.setup(cornerRadius: 24)
        cell.setup(isHideSeparator: false)
    }

    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        var categoryName = ""
        if self.isMyEvents == true && section == 0 {
            categoryName = "My upcoming events"
        } else {
            let eventCategoryObject = eventCategory[self.isMyEvents == true ? section - 1 : section]
            categoryName = eventCategoryObject.name
        }
        header.setup(title: categoryName)
        header.detailButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            // Open other user profile UI for test
            /*
            if section == 2 {
                unself.performSegue(withIdentifier: Segues.clubListSegue, sender: ClubListType.club)
            } else if section == 3 {
                unself.performSegue(withIdentifier: Segues.clubListSegue, sender: ClubListType.classes)
            } else {
                unself.performSegue(withIdentifier: Segues.createPost, sender: nil)
            }*/
        }
    }
}

// MARK: - Services
extension EventListViewController {
    func getEventList(sortBy: GetEventType) {
        
        let param = [Keys.profileUserId: Authorization.shared.profile?.userId ?? "",
                     Keys.search: searchText,
                     Keys.sortBy: sortBy.rawValue,
                     Keys.pageNo: pageNo] as [String: Any]
        
        ServiceManager.shared.fetchEventCategoryList(params: param) { [weak self] (value, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let category = value {
                unsafe.eventCategory = category
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }

}
