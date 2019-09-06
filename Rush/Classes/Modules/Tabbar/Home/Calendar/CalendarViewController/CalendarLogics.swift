//
//  CalendarPresenter.swift
//  Rush
//
//  Created by kamal on 07/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension CalendarViewController {

    private func restuctureEventGroup(events: [Event]) {
        
        events.forEach { (event) in
            let dateString = event.date?.toString(format: "yyyy-MM-dd")
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
        /// load list of events in child view controller
        child?.loadEvents(groups: groups)

    }
}

// MARK: - API's
extension CalendarViewController {
    
    func fetchEvents() {
        if let path = Bundle.main.path(forResource: "event", ofType: "json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
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
}
