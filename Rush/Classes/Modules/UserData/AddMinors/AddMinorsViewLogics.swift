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

//MARK: - Manage Interator or API's Calling
extension AddMinorsViewController {
    func getMinorList(searchText: String) {
        //Utils.showSpinner()
        ServiceManager.shared.getMinorList(params: ["search": searchText]) {
            [weak self] (data, errorMessage) in
            guard let self_ = self else { return }
            guard let list = data?["list"] as? [[String: Any]] else { return }
            self_.minorArray = list
            if self_.customMinorArray.count > 0 {
                for object in self_.customMinorArray {
                    self_.minorArray.append(object)
                }
            }
            if self_.searchTextField.text?.isEmpty == false {
                if self_.minorArray.contains(where: {$0["name"] as? String == self_.searchTextField.text} ) {
                    self_.minorCustomButton.isHidden = true
                }
                else {
                    self_.minorCustomButton.isHidden = false
                }
            }
          
            self_.tableView.reloadData()
        }
    }
    
    func updateProfileAPI() {
        
        
        let param = [Keys.uEduMinors: selectedArray]  as [String : Any]
        
        Utils.showSpinner()
        ServiceManager.shared.updateProfile(params: param) {
            [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let self_ = self else { return }
            if data != nil {
                self_.profileUpdateSuccess()
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
    

}
