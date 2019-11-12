//
//  UserInteresLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension UserInterestViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return 1
    }
    
    func fillTagCell(_ cell: UserTagCell, indexPath: IndexPath) {
        if isSearch == true {
            let tagarray = searchArray.map({ $0.interestName })
            cell.setupInterest(tagList: tagarray)
            cell.tagListView.delegate = self
        } else {
            let tagarray = interestArray.map({ $0.interestName })
            cell.setupInterest(tagList: tagarray)
            cell.tagListView.delegate = self
        }
    }
}

// MARK: - Manage Interator or API's Calling
extension UserInterestViewController {
    
}

extension UserInterestViewController: TagListViewDelegate {
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        //print("Tag pressed: \(title), \(sender)")
        self.tableView.reloadData()
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        //print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
        let tagarray = interestArray.map({ $0.interestName })
        if tagarray.contains(title) {
            if isSearch == true {
                guard let index = searchArray.firstIndex(where: { $0.interestName == title }) else { return }
                searchArray.remove(at: index)
            }
            guard let index = interestArray.firstIndex(where: { $0.interestName == title }) else { return }
            interestArray.remove(at: index)
        }
        interestButtonVisiable()
    }
    
}

// MARK: - Manage Interator or API's Calling
extension UserInterestViewController {
    
    func updateProfileAPI() {
        let interestIdArray = interestArray.map({ String($0.interestId) })
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
