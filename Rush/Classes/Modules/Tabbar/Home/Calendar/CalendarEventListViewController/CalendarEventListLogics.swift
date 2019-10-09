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
            cell.set(url: event.photo?.urlThumb())
            
            if event.type.lowercased() == "event" {
                cell.set(start: event.start, end: event.end)
            } else if let date = Date.parse(dateString: group.dateString, format: "yyyy-MM-dd") {
                if let schedule = event.classSchedule?.filter({ $0.day == date.toString(format: "EEEE").lowercased() }).last {
                    let startTime = Date.parseUTC(dateString: schedule.start, format: "HH:mm:ss")
                    let endTime = Date.parseUTC(dateString: schedule.end, format: "HH:mm:ss")
                    cell.set(start: startTime, end: endTime)
                }
            }

            if group.events.count - 1 == indexPath.row {
                cell.set(isNormal: true)
            } else {
                cell.set(isNormal: false)
            }
        }
    }
    
    func selectedRow(_ indexPath: IndexPath) {
        if let group = groups?[indexPath.section] {
           let event = group.events[indexPath.row]
            if event.type.lowercased() == "event" {
                showEvent(eventId: event.id)
            } else {
                showClass(classId: event.id)
            }
        }
    }
}

// MARK: - Other function
extension CalendarEventListViewController {
}
