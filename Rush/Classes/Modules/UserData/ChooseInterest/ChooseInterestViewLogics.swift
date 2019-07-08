//
//  AddMinorsViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ChooseInterestViewController {
    
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return 1
    }
    
    func fillTagCell(_ cell: ChooseTagCell) {
        cell.setupInterest(tagList: interestArray)
        cell.tagListView.delegate = self

    }

    

}

//MARK: - Manage Interator or API's Calling
extension ChooseInterestViewController {
    
}


extension ChooseInterestViewController: TagListViewDelegate {
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        //print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        if tagView.isSelected == true {
            selectedArray.append(title)
        }
        else {
            if selectedArray.contains(title) {
                let index = selectedArray.firstIndex(of: title)
                selectedArray.remove(at: index ?? 0)
            }
        }
        self.bottomView.isHidden = selectedArray.count > 2 ? false : true
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        //print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
}
