//
//  ClubListLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension SearchClubViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return searchType == .classes ? classesList.count : categoryList.count
    }
    
    func fillCell(_ cell: SearchClubCell, _ indexPath: IndexPath) {
        if searchType == .classes {
            cell.setup(title: classesList[indexPath.row])
        } else {
            cell.setup(title: categoryList[indexPath.row])
        }
        cell.setup(isHideTopSeparator: indexPath.row == 0 ? false : true)
    }
    
    func fillMyClubCell(_ cell: FriendClubCell, _ indexPath: IndexPath) {
        cell.setup(detail: "We have you to code better")
    }

    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(title: Text.exploreTopics)
        header.setup(isDetailArrowHide: true)
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        if searchType == .searchList {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerId.searchClubViewController) as? SearchClubViewController {
                vc.searchType = .searchCategory
                vc.searchText = categoryList[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            
        }
    }
}

extension SearchClubViewController: UITextFieldDelegate {
    @objc func textDidChange(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Utils.notReadyAlert()
        textField.resignFirstResponder()
        return true
    }
}
