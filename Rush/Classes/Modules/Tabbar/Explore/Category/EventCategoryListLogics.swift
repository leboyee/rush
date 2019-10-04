//
//  FriendsListLogics.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import PanModal

extension EventCategoryListViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return 50
    }
    
    func fillCategoryCell(_ cell: EventByDateCell, _ indexPath: IndexPath) {
        
    }
    
    func fillSortingCell(_ cell: SortingCell, _ indexPath: IndexPath) {
        
        var title = ""
        if type == .none {
            title = indexPath.item == 0 ? "All upcoming" : indexPath.item == 1 ? "Any time" : "Friends"
        } else if type == .event {
            title = indexPath.item == 0 ? "All upcoming" : indexPath.item == 1 ? "Any time" : "All people"
        } else if type == .club || type == .classes {
            title = indexPath.item == 0 ? "All categories" : indexPath.item == 1 ? "Popular first" : "All people"
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
        
        guard let eventCategoryFilter = UIStoryboard(name: "Event", bundle: nil).instantiateViewController(withIdentifier: "EventCateogryFilterViewController") as? EventCateogryFilterViewController & PanModalPresentable else { return }
        eventCategoryFilter.dataArray = indexPath.item == 0 ? Utils.upcomingFiler() : indexPath.item == 1 ? Utils.anyTimeFilter() : Utils.friendsFilter()
        let rowViewController: PanModalPresentable.LayoutType = eventCategoryFilter
        presentPanModal(rowViewController)
        collectionView.reloadData()
    }
    
    func fillClubCell(_ cell: FriendClubCell, _ indexPath: IndexPath) {
        if type == .club {
            
        } else {
            cell.setup(detail: "SOMM 24-A")
        }
    }
}
