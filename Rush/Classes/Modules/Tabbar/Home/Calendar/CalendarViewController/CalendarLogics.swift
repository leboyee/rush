//
//  CalendarPresenter.swift
//  Rush
//
//  Created by kamal on 07/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension CalendarViewController {

    private func restuctureEventInGroup(events: [CalendarItem]?) {
        
        // Load Events
        events?.forEach { (event) in
            let dateString = event.start?.toString(format: "yyyy-MM-dd")
            guard var group = groups.first(where: { $0.dateString == dateString }) else {
                let group = EventGroup(dateString: dateString ?? "", events: [event])
                groups.append(group)
                return
            }
            group.events.append(event)
            if let index = groups.firstIndex(where: { $0.dateString == dateString }) {
                groups[index] = group
            }
        }
    }
    
    private func restuctureClassesInGroup(classes: [CalendarItem]?, startDate: String, endDate: String) {
        
        guard classes?.count ?? 0 > 0 else { return }
        // Load Classes
        if var start = Date.parse(dateString: startDate, format: "yyyy-MM-dd"), let end = Date.parse(dateString: endDate, format: "yyyy-MM-dd") {
            while start <= end {
                let day = start.toString(format: "EEEE").lowercased()
                let list = classes?.filter({ ($0.classSchedule?.contains(where: { $0.day.lowercased().trimmingCharacters(in: CharacterSet.whitespaces) == day }) ?? false) })
                let dateString = start.toString(format: "yyyy-MM-dd")
                for listItem in list ?? [] {
                    let item = listItem.copy()
                    if let schedule = item.classSchedule?.filter({ $0.day.lowercased().trimmingCharacters(in: CharacterSet.whitespaces) == start.toString(format: "EEEE").lowercased() }).last {
                        let startDateStr = dateString + " " + schedule.start
                        let endDateStr = dateString + " " + schedule.end
                        //item.start = Date.parseUTC(dateString: startDateStr, format: "yyyy-MM-dd HH:mm:ss")
                        //item.end = Date.parseUTC(dateString: endDateStr, format: "yyyy-MM-dd HH:mm:ss")
                        item.start = Date.parse(dateString: startDateStr, format: "yyyy-MM-dd HH:mm:ss")
                        item.end = Date.parse(dateString: endDateStr, format: "yyyy-MM-dd HH:mm:ss")
                    }
                                  
                    guard var group = groups.first(where: { $0.dateString == dateString }) else {
                        let group = EventGroup(dateString: dateString, events: [item])
                        groups.append(group)
                        continue
                    }
                    
                    group.events.append(item)
                    if let index = groups.firstIndex(where: { $0.dateString == dateString }) {
                        groups[index] = group
                    }
                }
                start = start.plus(days: 1)
            }
        }
    }
}

// MARK: - API's
extension CalendarViewController {
    
    func fetchEvents(startDate: String, endDate: String) {
        Utils.showSpinner()
        let params = [Keys.startDate: startDate, Keys.endDate: endDate]
        ServiceManager.shared.fetchCalendarList(params: params) { [weak self] (events, classes, isScheduledAnything, _) in
            Utils.hideSpinner()
            self?.groups.removeAll()
            self?.restuctureEventInGroup(events: events)
            self?.restuctureClassesInGroup(classes: classes, startDate: startDate, endDate: endDate)
            self?.isScheduledAnything = isScheduledAnything
            // load list of events in child view controller
            self?.loadChildList()
            self?.updateView()
        }
    }
}
