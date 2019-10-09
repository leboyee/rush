//
//  EventCateogryFilterLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 28/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension EventCateogryFilterViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return isEventTypeModel == true ? UITableView.automaticDimension : 64//UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return dataArray.count
    }
    
    func fillCell(_ cell: EventCategoryFilterCell, _ indexPath: IndexPath) {
        let name = dataArray[indexPath.row]
        cell.setup(name: name)
        cell.setup(checkMarkHidden: indexPath.row == selectedIndex ? false : true)
    }
    
    func fillModelCell(_ cell: EventTypeModelCell, _ indexPath: IndexPath) {
        cell.set(type: indexPath.row == 0 ? .publik : indexPath.row == 1 ? .closed : .inviteOnly)
        cell.setup(checkMarkHidden: indexPath.row == selectedIndex ? false : true)
        cell.setup(isSelected: indexPath.row == selectedIndex ? true : false)
    }
    
    func fillTextHeader(_ header: EventCategoryFilterHeader, _ section: Int) {
        header.setup(name: headerTitle)
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        if isEventTypeModel == true {
            delegate?.selectedIndex("\(indexPath.row)")
            dismiss(animated: true, completion: nil)
        } else {
            let name = dataArray[indexPath.row]
                   delegate?.selectedIndex(name)
                   dismiss(animated: true, completion: nil)
        }
       
    }
}

// MARK: - Services
extension EventCateogryFilterViewController {
    
}
