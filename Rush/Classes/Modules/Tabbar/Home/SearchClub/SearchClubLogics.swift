//
//  ClubListLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension SearchClubViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return dataList.count
    }
    
    func fillCell(_ cell: SearchClubCell, _ indexPath: IndexPath) {
        if searchType == .searchList, let data = dataList[indexPath.row] as? ClubCategory {
            cell.setup(title: data.name)
        } else {
            
        }
        cell.setup(isHideTopSeparator: indexPath.row == 0 ? false : true)
    }
    
    func fillMyClubCell(_ cell: FriendClubCell, _ indexPath: IndexPath) {
        cell.setup(detail: "We have you to code better")
    }

    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(title: Text.exploreTopics)
        header.setup(isDetailArrowHide: true)
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        if searchType == .searchList {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerId.searchClubViewController) as? SearchClubViewController {
                vc.searchType = .searchCategory
                vc.searchText = (dataList[indexPath.row] as? ClubCategory)?.name ?? ""
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            
        }
    }
}

extension SearchClubViewController: UITextFieldDelegate {
    @objc func textDidChange(_ textField: UITextField) {
        searchText = textField.text ?? ""
        getClubCategoryListAPI(isShowSpinner: false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Utils.notReadyAlert()
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Services
extension SearchClubViewController {
    
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
