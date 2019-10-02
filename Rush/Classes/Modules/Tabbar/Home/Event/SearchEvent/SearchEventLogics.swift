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
        header.setup(title: Text.exploreTopics)
        header.setup(isDetailArrowHide: true)
    }
    
    func cellSelected(_ indexPath: IndexPath) { /*
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerId.searchClubViewController) as? SearchClubViewController {
                vc.searchType = .searchCategory
                vc.searchText = (dataList[indexPath.row] as? ClubCategory)?.name ?? ""
                navigationController?.pushViewController(vc, animated: true)
            }*/
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
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }

    func getClubCategoryListAPI(isShowSpinner: Bool) {
        if isShowSpinner {
            Utils.showSpinner()
        }
        let param = [Keys.search: searchText] as [String: Any]
        ServiceManager.shared.fetchClubCategoryList(params: param) { [weak self] (data, errorMsg) in
            Utils.hideSpinner()
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
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
