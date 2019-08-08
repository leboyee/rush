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
        return groups.count
    }
    
    func sectionHeight(_ section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func cellCount(_ section: Int) -> Int {
        let group = groups[section]
        return group.events.count
    }
    
    func fillEventCell(_ cell: CalendarEventCell, _ indexPath: IndexPath) {
        let group = groups[indexPath.section]
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
    
    func selectedRow(_ indexPath: IndexPath) {
        
    }
}

//MARK: -Other function
extension CalendarEventListViewController {

    private func restuctureEventGroup(events: [Event]) {
        
        
        events.forEach { (event) in
            let dateString = event.date.toString(format: "yyyy-MM-dd")
            guard var group = groups.first(where: { $0.dateString == dateString}) else {
                let group = EventGroup(dateString: dateString, events: [event])
                groups.append(group)
                return
            }
            group.events.append(event)
            if let index = groups.firstIndex(where: { $0.dateString == dateString}) {
                groups[index] = group
            }
        }
        tableView.reloadData()
        
    }
    
}

//MARK: - API's
extension CalendarEventListViewController {
    
    func fetchEvents() {
    
        if let path = Bundle.main.path(forResource: "event", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                if let list = try jsonDecoder.decode([Event].self, from: data) as [Event]? {
                    restuctureEventGroup(events: list)
                }
            } catch {
                print("Unexpected error: \(error).")
            }
        }
    }
}
