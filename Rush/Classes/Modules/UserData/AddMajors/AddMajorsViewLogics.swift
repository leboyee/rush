//
//  AddMajorsViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension AddMajorsViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
            return 56
    }
    
    func cellCount(_ section: Int) -> Int {
        return majorArray.count
    }
    
    func fillAddMajorCell(_ cell: AddMajorsCell, _ indexPath: IndexPath) {
        let major = majorArray[indexPath.row]
        cell.setup(title: major["name"] as? String ?? "")
        cell.setup(isSelected: selectedArray.contains(major["name"] as? String ?? ""))
    }
}

// MARK: - Manage Interator or API's Calling
extension AddMajorsViewController {
    
    func getMajorList(searchText: String) {
        //Utils.showSpinner()
        ServiceManager.shared.getMajorList(params: ["search": searchText]) { [weak self] (data, _) in
            guard let unsafe = self else { return }
            guard let list = data?["list"] as? [[String: Any]] else { return }
            unsafe.majorArray = list
            unsafe.tableView.reloadData()
        }
    }
    
    func updateProfileAPI() {
        let param = [Keys.uEduMajors: selectedArray]  as [String: Any]
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
