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
        if isSearch == true {
            let interestNameArray = interestArray.map({ $0.interestName })
            cell.setupInterest(tagList: interestNameArray)
            cell.tagListView.delegate = self
        } else if Authorization.shared.profile?.interest?.count ?? 0 > 0 && indexPath.section == 0 {
            let interestProfileArray = Authorization.shared.profile?.interest ?? [Interest]()
            let tagarray = interestProfileArray.map({ $0.interestName })
            cell.setupInterest(tagList: tagarray)
            cell.tagListView.delegate = self
        } else {
            let interestNameArray = interestArray.map({ $0.interestName })
            cell.setupInterest(tagList: interestNameArray)
            cell.tagListView.delegate = self
        }
        cell.selectedTag(tagList: selectedArray.map({ $0.interestName }))

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
        let interestProfileArray = Authorization.shared.profile?.interest ?? [Interest]()
        if interestArray.contains(where: { $0.interestName == title }) {
            if tagView.isSelected == true {
                guard let index = interestArray.firstIndex(where: { $0.interestName == title }) else { return }
                selectedArray.append(interestArray[index])
            } else {
                guard let index = selectedArray.firstIndex(where: { $0.interestName == title }) else { return }
                selectedArray.remove(at: index)
            }
            
        }
        if interestProfileArray.contains(where: { $0.interestName == title }) {
            if tagView.isSelected == true {
                guard let index = interestProfileArray.firstIndex(where: { $0.interestName == title }) else { return }
                selectedArray.append(interestProfileArray[index])
            } else {
                guard let index = selectedArray.firstIndex(where: { $0.interestName == title }) else { return }
                selectedArray.remove(at: index)
            }
        }
        self.tableView.reloadData()
        self.interestButtonVisiable()
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        //print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
    
}

// MARK: - Manage Interator or API's Calling
extension CreateEventInterestViewController {
    
    func getInterestList(search: String) {
        //Utils.showSpinner()
        ServiceManager.shared.getInterestList(params: [Keys.search: search]) { [weak self] (data, _) in
            guard let unsafe = self else { return }
            if let interest = data {
                unsafe.interestArray = interest
            let myInterestArray = Authorization.shared.profile?.interest
                if unsafe.isSearch == false {
                    if myInterestArray?.count ?? 0 > 0 {
                        if unsafe.interestArray.count > 0 {
                            for interest in unsafe.interestArray {
                                if myInterestArray?.contains(where: { $0.interestName == interest.interestName }) ?? false {
                                    guard let index = unsafe.interestArray.firstIndex(where: { $0.interestName == interest.interestName }) else { return }
                                    unsafe.interestArray.remove(at: index)
                                }
                            }
                        }
                    }
                }
                unsafe.tableView.reloadData()
            }
        }
    }

}
