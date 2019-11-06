//
//  AddMinorsViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ChooseInterestViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return 1
    }
    
    func fillTagCell(_ cell: ChooseTagCell) {
        let interestNameArray = interestArray.map({ $0.interestName })
        cell.setupInterest(tagList: interestNameArray)
        cell.tagListView.delegate = self

    }
}

// MARK: - Manage Interator or API's Calling
extension ChooseInterestViewController {
    
}

extension ChooseInterestViewController: TagListViewDelegate {
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        //print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        if tagView.isSelected == true {
            guard let index = interestArray.firstIndex(where: { $0.interestName == title }) else { return }
            selectedArray.append(interestArray[index])
        } else {
            guard let index = selectedArray.firstIndex(where: { $0.interestName == title }) else { return }
                selectedArray.remove(at: index)
        }
        self.bottomView.isHidden = selectedArray.count > 2 ? false : true
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        //print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
}

// MARK: - Manage Interator or API's Calling
extension ChooseInterestViewController {
    
    func getInterestList() {
        //Utils.showSpinner()
        ServiceManager.shared.getInterestList(params: [:]) { [weak self] (data, _) in
            guard let unsafe = self else { return }
            if let list = data {
                unsafe.interestArray = list
                unsafe.tableView.reloadData()
            }
        
        }
    }
    
    func updateProfileAPI() {
        
        let interestIdArray = selectedArray.map({ String($0.interestId) })
        let selectedIdArray = interestIdArray.joined(separator: ",")
        var param = [Keys.userInterests: selectedIdArray
            ]  as [String: Any]
        param[Keys.userStep] = 3

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
