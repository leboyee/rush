//
//  CalendarPresenter.swift
//  Rush
//
//  Created by kamal on 07/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension CalendarViewController {

    private func restuctureEventGroup(events: [CalendarItem]) {
        
        events.forEach { (event) in
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
        
        /// load list of events in child view controller
        loadChildList()
    }
}

// MARK: - API's
extension CalendarViewController {
    
    func fetchEvents(startDate: String, endDate: String) {
        Utils.showSpinner()
        let params = [Keys.startDate: startDate, Keys.endDate: endDate]
        ServiceManager.shared.fetchCalendarList(params: params) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            if let list = data {
                self?.restuctureEventGroup(events: list)
            }
        }
    }
}
