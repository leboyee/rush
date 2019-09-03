//
//  AddMinorsViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension AddMinorsViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
            return 56
    }
    
    func cellCount(_ section: Int) -> Int {
        return minorArray.count
    }
    
    func fillAddMajorCell(_ cell: AddMajorsCell, _ indexPath: IndexPath) {
        let major = minorArray[indexPath.row]
        cell.setup(title: major["name"] as? String ?? "")
        cell.setup(isSelected: selectedArray.contains(major["name"] as? String ?? ""))    }
}

// MARK: - Manage Interator or API's Calling
extension AddMinorsViewController {
    func getMinorList(searchText: String) {
        //Utils.showSpinner()
        ServiceManager.shared.getMinorList(params: ["search": searchText]) { [weak self] (data, errorMessage) in
            guard let unsafe = self else { return }
            guard let list = data?["list"] as? [[String: Any]] else { return }
            unsafe.minorArray = list
            if unsafe.customMinorArray.count > 0 {
                for object in unsafe.customMinorArray {
                    unsafe.minorArray.append(object)
                }
            }
            if unsafe.searchTextField.text?.isEmpty == false {
                if unsafe.minorArray.contains(where: {$0["name"] as? String == unsafe.searchTextField.text} ) {
                    unsafe.minorCustomButton.isHidden = true
                } else {
                    unsafe.minorCustomButton.isHidden = false
                }
            }
          
            unsafe.tableView.reloadData()
        }
    }
    
    func updateProfileAPI() {
        let param = [Keys.uEduMinors: selectedArray]  as [String: Any]
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
