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
            
            //var eventDate: Date?
            var startTime: Date?
            var endTime: Date?
            if event.type.lowercased() == "event" {
                cell.set(start: event.start, end: event.end)
                //eventDate = event.start
                startTime = event.start
                endTime = event.end
            } else if let date = Date.parse(dateString: group.dateString, format: "yyyy-MM-dd") {
                //eventDate = date
                if let schedule = event.classSchedule?.filter({ $0.day == date.toString(format: "EEEE").lowercased() }).last {
                    startTime = Date.parseUTC(dateString: schedule.start, format: "HH:mm:ss")
                    endTime = Date.parseUTC(dateString: schedule.end, format: "HH:mm:ss")
                    cell.set(start: startTime, end: endTime)
                }
            }
            
            cell.set(isHideRedTimeline: true)
            if indexPath.row == 0 || tableView.numberOfRows(inSection: indexPath.section) - 1 == indexPath.row {
               cell.set(isHideTop: true)
               cell.set(isHideBottom: false)
            } else {
                cell.set(isHideTop: false)
                cell.set(isHideBottom: true)
            }
            /*
            if eventDate?.isToday() ?? false {
                let date = Date()
                if let start = startTime, let end = endTime {
                    if date.isGreaterThan(start), date.isLessThan(end) {
                        cell.set(isHideRedTimeline: false)
                        cell.set(isHideTop: false)
                        cell.set(isHideBottom: true)
                    }
                }
            }*/
        }
    }
    
    func selectedRow(_ indexPath: IndexPath) {
        if let group = groups?[indexPath.section] {
           let event = group.events[indexPath.row]
            if event.type.lowercased() == "event" {
                showEvent(eventId: event.itemId)
            } else {
                let classId = Int64(event.itemId) ?? 0
                showClass(classId: classId, groupId: event.groupId)
            }
        }
    }
}

// MARK: - Other function
extension CalendarEventListViewController {
}
