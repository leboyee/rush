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
        return isEventTypeModel == true ? 123 : 64//UITableView.automaticDimension
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
        let name = dataArray[indexPath.row]
        let details = Utils.eventTypDetailsArray()[indexPath.row]
        cell.setup(name: name)
        cell.setup(checkMarkHidden: indexPath.row == selectedIndex ? false : true)
        cell.setup(detail: details)
        cell.setup(isSelected: indexPath.row == selectedIndex ? true : false)
    }
    
    func fillTextHeader(_ header: EventCategoryFilterHeader, _ section: Int) {
        header.setup(name: headerTitle)
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        let name = dataArray[indexPath.row]
        delegate?.selectedIndex(name)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Services
extension EventCateogryFilterViewController {
    
}
