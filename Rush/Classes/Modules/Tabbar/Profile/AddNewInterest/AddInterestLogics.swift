//
//  UserInteresLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension AddInterestViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return 1
    }
    
    func fillTagCell(_ cell: ChooseTagCell, indexPath: IndexPath) {
//        if isSearch == true {
//            let tagarray = searchArray.map({ $0.interestName })
//            cell.setupInterest(tagList: tagarray)
//            cell.tagListView.delegate = self
//        } else {
            let tagarray = interestArray.map({ $0.interestName })
            cell.setupInterest(tagList: tagarray)
            cell.tagListView.delegate = self
       // }
        cell.selectedTag(tagList: selectedArray.map({ $0.interestName }))

    }
}

// MARK: - Manage Interator or API's Calling
extension AddInterestViewController {
    
}

extension AddInterestViewController: TagListViewDelegate {
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        //print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        let interestMainArray = interestArray
        if tagView.isSelected == true {
            guard let index = interestMainArray.firstIndex(where: { $0.interestName == title }) else { return }
            selectedArray.append(interestMainArray[index])
        } else {
            guard let index = selectedArray.firstIndex(where: { $0.interestName == title }) else { return }
            selectedArray.remove(at: index)
        }
        interestButtonVisiable()
        self.tableView.reloadData()
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        //print("Tag Remove pressed: \(title), \(sender)")
    }
    
}

// MARK: - Manage Interator or API's Calling
extension AddInterestViewController {
    
    func getInterestList(searchText: String) {
        //Utils.showSpinner()
        interestArray.removeAll()
        ServiceManager.shared.getInterestList(params: [Keys.search: searchText]) { [weak self] (data, _) in
            guard let unsafe = self else { return }
            if let list = data {
                unsafe.interestArray = list
                unsafe.noResultView.isHidden = list.count > 0 ? true : false
                unsafe.tableView.reloadData()
            }
            
        }
    }
    
    func updateProfileAPI() {
        let interestIdArray = selectedArray.map({ String($0.interestId) })
        let selectedIdArray = interestIdArray.joined(separator: ",")
        let param = [Keys.userInterests: selectedIdArray]  as [String: Any]
        Utils.showSpinner()
        ServiceManager.shared.updateProfile(params: param) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if data != nil {
                unsafe.profileUpdateSuccess()
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
