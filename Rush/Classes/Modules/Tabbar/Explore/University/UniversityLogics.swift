//
//  FriendsListLogics.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension UniversityViewController {
    
    func cellCount(_ section: Int) -> Int {
        return universityArray.count
    }
    
    func fillPeopleCell(_ cell: PeopleCell, _ indexPath: IndexPath) {
        let university = universityArray[indexPath.row]
        cell.setup(title: university.universityName)
        cell.setup(universityUrl: URL(string: university.logo ?? ""))
        
        if selectedIndex == -1 && selectedUniversity != nil {
            if university.universtiyId == selectedUniversity?.universtiyId {
                cell.setup(isCheckMark: true)
            }
        } else {
            cell.setup(isCheckMark: selectedIndex == indexPath.row)
        }
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.delegate?.setSelectedUniversity(university: universityArray[selectedIndex])
        tableView.reloadData()
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func willDisplay(_ indexPath: IndexPath) {
        if isNextPageExist == true, indexPath.row == universityArray.count - 3 {
            pageNo += 1
            getUniversity()
        }
    }
}

// MARK: - Services
extension UniversityViewController {
    func getUniversity() {
        //Utils.showSpinner()
        if pageNo == 1 {
            universityArray.removeAll()
        }
        
        ServiceManager.shared.getUniversityList(params: ["search": searchText, Keys.pageNo: "\(pageNo)"]) { [weak self] (value, _) in
            guard let unsafe = self else { return }
    
            if value?.count ?? 0 > 0 {
                if unsafe.pageNo == 1 {
                    unsafe.universityArray = value ?? [University]()
                } else {
                    unsafe.universityArray.append(contentsOf: value ?? [University]())
                }
                unsafe.isNextPageExist = true
            } else {
                unsafe.isNextPageExist = false
            }
            
            unsafe.tableView.reloadData()
        }
    }
}
