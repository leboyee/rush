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
            if let data = dataList[indexPath.row] as? ClassGroup {
                cell.setup(title: data.name)
            } else if let data = dataList[indexPath.row] as? Interest {
                cell.setup(title: data.interestName)
            }
        }
        cell.setup(isHideTopSeparator: indexPath.row == 0 ? false : true)
    }
    
    func fillMyClubCell(_ cell: FriendClubCell, _ indexPath: IndexPath) {
        if let club = dataList[indexPath.row] as? Club {
            let image = Image(json: club.clubPhoto ?? "")
            cell.setup(title: club.clubName ?? "")
            cell.setup(detail: club.clubDesc ?? "")
            cell.setup(invitee: club.invitees)
            cell.setup(clubImageUrl: image.urlThumb())
            if club.clubTotalJoined > 3 {
                cell.setup(inviteeCount: club.clubTotalJoined - 3)
            } else {
                cell.setup(inviteeCount: 0)
            }
        }
    }

    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(title: Text.exploreTopics)
        header.setup(isDetailArrowHide: true)
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        if searchType == .searchList {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerId.searchClubViewController) as? SearchClubViewController {
                vc.searchType = .searchCategory
                if let data = dataList[indexPath.row] as? ClubCategory {
                    vc.searchText = data.name
                } else if let data = dataList[indexPath.row] as? Interest {
                    vc.selectedCategory = data
                    vc.searchText = data.interestName
                    if let clubs = data.clubArray {
                        vc.dataList = clubs
                    }
                }
                navigationController?.pushViewController(vc, animated: true)
            }
        } else if searchType == .classes {
            let classGroup = dataList[indexPath.row] as? ClassGroup
            self.performSegue(withIdentifier: Segues.classDetailSegue, sender: classGroup)
        } else if selectedCategory != nil {
            if let club = dataList[indexPath.row] as? Club {
                performSegue(withIdentifier: Segues.clubDetailSegue, sender: club)
            }
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
        searchText = textField.text ?? ""
        getClubCategoryListAPI(isShowSpinner: false)
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
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func getClassGroupListAPI(isShowSpinner: Bool) {
        if isShowSpinner {
            Utils.showSpinner()
        }
        let classId = classObject.id
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
    
    func getClubListAPI() {
        
        if pageNo == 1 {
            dataList.removeAll()
        }
        
        var param = [Keys.search: "",
                     Keys.sortBy: "feed",
                     Keys.pageNo: pageNo] as [String: Any]
        
        if let interest = selectedCategory as? Interest {
            param[Keys.intId] = interest.interestId
        }
        
        if tabBarController?.selectedIndex == 0 {
            param[Keys.universityId] = Authorization.shared.profile?.university?.first?.universtiyId ?? 0
        }
        
        if pageNo == 1 {
            Utils.showSpinner()
        }
        
        ServiceManager.shared.fetchClubList(sortBy: "feed", params: param) { [weak self] (value, _, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let clubs = value {
                if clubs.count > 0 {
                    if unsafe.pageNo == 1 {
                        unsafe.dataList = clubs
                    } else {
                        unsafe.dataList.append(contentsOf: clubs)
                    }
                    unsafe.isNextPage = true
                    unsafe.tableView.reloadData()
                } else {
                    unsafe.isNextPage = false
                }
            } else {
                unsafe.isNextPage = false
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
