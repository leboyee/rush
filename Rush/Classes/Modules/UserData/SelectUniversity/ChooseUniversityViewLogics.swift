//
//  ChooseYearViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ChooseUniversityViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return universityArray.count
    }
    
    func fillChooseUniversityCell(_ cell: UniversityCell, _ indexPath: IndexPath) {
        let university = universityArray[indexPath.row]
        cell.setup(title: university.universityName)
        if let url = URL(string: university.logo ?? "") {
                   cell.setup(url: url)
        }
        cell.setup(checkMark: selectedIndex == indexPath.row ? true : false)
    }
    
    func willDisplay(_ indexPath: IndexPath) {
           if isNextPageExist == true, indexPath.row == universityArray.count - 1 {
            getUniversity(searchText: searchTextField.text ?? "")
           }
       }
}

// MARK: - Manage Interator or API's Calling
extension ChooseUniversityViewController {
    
    func getUniversity(searchText: String) {
        //Utils.showSpinner()
        
        task?.cancel()
        task = ServiceManager.shared.getUniversityListWithSession(params: ["search": searchText, Keys.pageNo: "\(pageNo)"]) { [weak self] (value, _) in
            guard let unsafe = self else { return }
            if unsafe.pageNo == 1 {
                unsafe.universityArray.removeAll()
            }
                
            if value?.count ?? 0 > 0 {
                if unsafe.pageNo == 1 {
                    unsafe.universityArray = value ?? [University]()
                } else {
                    unsafe.universityArray.append(contentsOf: value ?? [University]())
                }
                unsafe.pageNo += 1
                unsafe.isNextPageExist = true
            } else {
                unsafe.isNextPageExist = false
                if unsafe.pageNo == 1 {
                    unsafe.universityArray.removeAll()
                }
            }
            
            if let index = unsafe.universityArray.firstIndex(where: { $0.universtiyId == unsafe.selectedUniversity?.universtiyId }) {
                unsafe.selectedIndex = index
            } else {
                unsafe.selectedIndex = -1
            }
            unsafe.noResultView.isHidden = unsafe.universityArray.count > 0 ? true : false
            unsafe.tableView.reloadData()
        }
    }
    
    func updateProfileAPI() {
        let university = universityArray[selectedIndex]
        var param = [Keys.uUniversity: "\(university.universtiyId)"]  as [String: Any]

        if addUniversityType == .register {
            param[Keys.userStep] = 0
        }
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
