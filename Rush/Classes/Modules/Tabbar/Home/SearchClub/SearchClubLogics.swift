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
            let data = dataList[indexPath.row] as? ClassGroup
            cell.setup(title: data?.name ?? "")
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
        } else if searchType == .classes {
            let classGroup = classObject.classGroups?[indexPath.row]
            self.performSegue(withIdentifier: Segues.classDetailSegue, sender: classGroup)
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
            if let category = data {
                unsafe.dataList = category
            }
            unsafe.tableView.reloadData()
        }
    }
    
    func getClassGroupListAPI(isShowSpinner: Bool) {
        if isShowSpinner {
            Utils.showSpinner()
        }
        let classId = classObject.id
//        classId = "5d8df9751140e8a99272b8a4"
        let param = [Keys.pageNo: pageNo, Keys.classId: classId, Keys.search: ""] as [String: Any]
        
        ServiceManager.shared.fetchClassGroupList(classId: classId, params: param) { [weak self] (data, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let value = data {
                unsafe.dataList = value
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
}
