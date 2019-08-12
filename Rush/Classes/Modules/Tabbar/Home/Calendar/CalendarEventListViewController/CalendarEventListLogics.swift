//
//  CalendarEventListLogics.swift
//  Rush
//
//  Created by kamal on 07/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension CalendarEventListViewController {
    
    func sectionCount() -> Int {
        return groups?.count ?? 0
    }
    
    func sectionHeight(_ section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func cellCount(_ section: Int) -> Int {
        let group = groups?[section]
        return group?.events.count ?? 0
    }
    
    func fillEventCell(_ cell: CalendarEventCell, _ indexPath: IndexPath) {
        if let group = groups?[indexPath.section] {
            let event = group.events[indexPath.row]
            cell.set(eventName: event.title)
            cell.set(type: event.type)
            cell.set(start: event.start, end: event.end)
            cell.set(path: event.thumbnil)
            
            if indexPath.row == 0 {
                cell.set(date: event.date)
            } else {
                cell.set(date: nil)
            }
            
            if group.events.count - 1 == indexPath.row {
                cell.set(isNormal: true)
            } else {
                cell.set(isNormal: false)
            }
        }
    }
    
    func selectedRow(_ indexPath: IndexPath) {
        
    }
}

//MARK: -Other function
extension CalendarEventListViewController {


    
}


