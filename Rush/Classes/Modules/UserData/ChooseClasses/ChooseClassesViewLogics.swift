//
//  AddMinorsViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ChooseClassesViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return 56
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
            return 56
    }
    
    func cellCount(_ section: Int) -> Int {
        if selectedIndex == section {
            return subClassArray.count
        } else {
            return 0
        }
    }
    
    func fillClassesCell(_ cell: ClassesCell, _ indexPath: IndexPath) {
        let subclassies = subClassArray[indexPath.row]
        cell.titleLabel.text = subclassies.name
    }
    
    func fillClassesHeader(_ header: ClassesHeader, _ section: Int) {
        let classies = classesArray[section]
        if selectedArray.contains(where: { $0.classId == classies.id }) {
            guard let index = selectedArray.firstIndex(where: { $0.classId == classies.id }) else { return }
            let subClass = selectedArray[index]
            header.setup(detailsLableText: subClass.name)
        } else {
            header.setup(detailsLableText: "")
        }
       
        header.titleLabel.text = classies.name
        header.headerButton.tag = section
        header.headerButton.addTarget(self, action: #selector(headerSelectionAction), for: .touchUpInside)
        header.arrowImageView.isHighlighted = section == selectedIndex ? true : false
    }
    
    @objc func headerSelectionAction(_ sender: UIButton) {
        if selectedIndex == sender.tag {
            selectedIndex = -1
            tableView.reloadData()
        } else {
            selectedIndex = sender.tag
            let classies = classesArray[sender.tag]
            subClassArray.removeAll()
            tableView.reloadData()
            getClassGroupListAPI(classId: classies.id)
        }
    }

}

// MARK: - Manage Interator or API's Calling
extension ChooseClassesViewController {
    
    func getClassListAPI() {
        let param = [Keys.pageNo: pageNo] as [String: Any]
        
        ServiceManager.shared.fetchClassList(params: param) { [weak self] (data, errorMsg) in
            guard let unsafe = self else { return }
            if let classes = data {
                unsafe.classesArray = classes
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }

    /*
    func getClassesList() {
        //Utils.showSpinner()
        ServiceManager.shared.getClassCategory(params: [:]) { [weak self] (data, errorMessage) in
            guard let unsafe = self else { return }
            if let classes = data {
                unsafe.classesArray = classes
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
            unsafe.tableView.reloadData()
        }
    }
    */
    
        func getClassGroupListAPI(classId: String) {

            Utils.showSpinner()
            let param = [Keys.pageNo: pageNo, Keys.classId: classId, Keys.search: ""] as [String: Any]
            
            ServiceManager.shared.fetchClassGroupList(classId: classId, params: param) { [weak self] (data, errorMsg) in
                Utils.hideSpinner()
                guard let unsafe = self else { return }
                if let value = data {
                    unsafe.subClassArray = value
                    unsafe.tableView.reloadData()
                } else {
                    Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
                }
            }
        }

    /*
    func getSubClassList(classId: String) {
        Utils.showSpinner()
        ServiceManager.shared.getSubClass(classId: classId, params: [Keys.pageNo: pageNo]) { [weak self] (data, errorMessage) in
               guard let unsafe = self else { return }
            Utils.hideSpinner()
               if let classes = data {
                   unsafe.subClassArray = classes
                   unsafe.tableView.reloadData()
               } else {
                   Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
               }
            unsafe.tableView.reloadData()
           }
       }
    */
    func updateProfileAPI() {
        let param = [Keys.uEduMinors: selectedArray]  as [String: Any]
        Utils.showSpinner()
        ServiceManager.shared.updateProfile(params: param) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let _ = self else { return }
            if data != nil {
                //unsafe.profileUpdateSuccess()
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
