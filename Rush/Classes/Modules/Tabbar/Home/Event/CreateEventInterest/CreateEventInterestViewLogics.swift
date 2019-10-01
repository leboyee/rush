//
//  CreateEventInterestViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension CreateEventInterestViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return 1
    }
    
    func fillTagCell(_ cell: ChooseTagCell, indexPath: IndexPath) {
        if Authorization.shared.profile?.interest?.count ?? 0 > 0 && indexPath.section == 0 {
            guard let interestProfileArray = Authorization.shared.profile?.interest else { return }
            cell.setupInterest(tagList: interestProfileArray)
            cell.tagListView.delegate = self
        } else {
            let interestNameArray = interestArray.map({ $0.interestName })
            cell.setupInterest(tagList: interestNameArray)
            cell.tagListView.delegate = self
        }
    }
}

// MARK: - Manage Interator or API's Calling
extension CreateEventInterestViewController {
    
}

extension CreateEventInterestViewController: TagListViewDelegate {
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        //print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        if tagView.isSelected == true {
            selectedArray.append(title)
        } else {
            if selectedArray.contains(title) {
                let index = selectedArray.firstIndex(of: title)
                selectedArray.remove(at: index ?? 0)
            }
        }
        self.interestButtonVisiable()
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        //print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
}

// MARK: - Manage Interator or API's Calling
extension CreateEventInterestViewController {
    
    func getInterestList() {
        //Utils.showSpinner()
        ServiceManager.shared.getInterestList(params: [:]) { [weak self] (data, _) in
            guard let unsafe = self else { return }
            guard let list = data?["list"] as? [[String: Any]] else { return }
            let myInterestArray = Authorization.shared.profile?.interest
            unsafe.interestArray = list.map { (interest) -> Interest in
                return Interest(data: interest)
            }
            
            if myInterestArray?.count ?? 0 > 0 {
                if unsafe.interestArray.count > 0 {
                    for interest in unsafe.interestArray {
                        if myInterestArray?.contains(interest.interestName) ?? false {
                            guard let index = unsafe.interestArray.firstIndex(where: { $0.interestName == interest.interestName }) else { return }
                            unsafe.interestArray.remove(at: index)
                        }
                    }
                }
            }
            unsafe.tableView.reloadData()
        }
    }

}
