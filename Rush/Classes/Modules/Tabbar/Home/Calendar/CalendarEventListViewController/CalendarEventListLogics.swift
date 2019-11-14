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
            let placeholder = event.type.lowercased() == Text.event ? #imageLiteral(resourceName: "placeholder-event48px.pdf") : #imageLiteral(resourceName: "placeholder-classes48px.pdf")
            cell.set(url: event.photo?.urlThumb(), placeholder: placeholder)
            
            let date = Date()
            let (startTime, endTime) = getEventTimes(event: event, dateString: group.dateString)
            cell.set(start: startTime, end: endTime)

            cell.set(isHideRedTimeline: true)
            cell.set(isHideBottom: false)

            /// check next event time as we need red line only in last event with same timing
            /// so if next event time is also match with currrent time, than we return because we does not need to show red time here.
            let nextIndex = indexPath.row + 1
            if group.events.count > nextIndex {
                let nextEvent = group.events[nextIndex]
                let (startTimeNextEvent, endTimeNextEvent) = getEventTimes(event: nextEvent, dateString: group.dateString)
                if let start = startTimeNextEvent, let end = endTimeNextEvent {
                    if date.isGreaterThan(start), date.isLessThan(end) {
                        return
                    }
                }
            }
            
            if let start = startTime, let end = endTime {
                if date.isGreaterThan(start), date.isLessThan(end) {
                    cell.set(isHideRedTimeline: false)
                    cell.set(isHideBottom: true)
                }
            }
        }
    }
    
    func selectedRow(_ indexPath: IndexPath) {
        if let group = groups?[indexPath.section] {
           let event = group.events[indexPath.row]
            if event.type.lowercased() == "event" {
                showEvent(eventId: event.itemId)
            } else {
                showClass(classId: event.itemId, groupId: String(event.groupId))
            }
        }
    }
}

// MARK: - Other function
extension CalendarEventListViewController {
    private func getEventTimes(event: CalendarItem, dateString: String) -> (Date?, Date?) {
        var startTime: Date?
        var endTime: Date?
        if event.type.lowercased() == "event" {
            startTime = event.start
            endTime = event.end
        } else if let date = Date.parse(dateString: dateString, format: "yyyy-MM-dd") {
            if let schedule = event.classSchedule?.filter({ $0.day == date.toString(format: "EEEE").lowercased() }).last {
                let startDateStr = dateString + " " + schedule.start
                let endDateStr = dateString + " " + schedule.end
                startTime = Date.parseUTC(dateString: startDateStr, format: "HH:mm:ss")
                endTime = Date.parseUTC(dateString: endDateStr, format: "HH:mm:ss")
            }
        }
        return (startTime, endTime)
    }
}
