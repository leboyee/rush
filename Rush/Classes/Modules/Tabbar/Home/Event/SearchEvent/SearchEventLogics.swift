//
//  SearchEventLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 28/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension SearchEventViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return dataList.count
    }
    
    func fillCell(_ cell: SearchClubCell, _ indexPath: IndexPath) {
        if let data = dataList[indexPath.row] as? EventCategory {
            cell.setup(title: data.name)
        } else {
        }
        cell.setup(isHideTopSeparator: indexPath.row == 0 ? false : true)
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(title: searchText.isEmpty == true ? Text.exploreTopics : Text.searchResult)
        header.setup(isDetailArrowHide: true)
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        self.performSegue(withIdentifier: Segues.searchEventCategoryViewSegue, sender: indexPath)
    }
}

// MARK: - Services
extension SearchEventViewController {
    
    func getEventList(sortBy: GetEventType) {
        
        let param = [Keys.search: searchText,
                     Keys.pageNo: pageNo] as [String: Any]
        
        ServiceManager.shared.fetchEventCategoryList(params: param) { [weak self] (value, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let category = value {
                unsafe.dataList = category
                unsafe.noEventsView.isHidden = unsafe.dataList.count == 0 ? false : true
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
}
