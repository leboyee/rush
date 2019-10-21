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
        if let url = URL(string: university.logo ?? "") {
                   cell.setup(url: url)
        }
        cell.setup(isCheckMark: selectedIndex == indexPath.row)
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.delegate?.setSelectedUniversity(university: universityArray[selectedIndex])
        tableView.reloadData()
    }
    
    func willDisplay(_ indexPath: IndexPath) {
          if isNextPageExist == true, indexPath.row == universityArray.count - 3 {
           getUniversity(searchText: "")
          }
      }
}

// MARK: - Services
extension UniversityViewController {
    func getUniversity(searchText: String) {
           //Utils.showSpinner()
           ServiceManager.shared.getUniversityList(params: ["search": searchText, Keys.pageNo: "\(pageNo)"]) { [weak self] (value, _) in
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
               unsafe.tableView.reloadData()
           }
       }
       
}
