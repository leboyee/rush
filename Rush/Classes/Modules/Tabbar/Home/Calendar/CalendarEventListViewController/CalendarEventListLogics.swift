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
        return 20
    }
    
    func sectionHeight(_ section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func cellCount(_ section: Int) -> Int {
        return 1
    }
    
    func fillEventCell(_ cell: CalendarEventCell, _ indexPath: IndexPath) {
        
    }
    
    func selectedRow(_ indexPath: IndexPath) {
        
    }
}


//MARK: - API's
extension CalendarEventListViewController {
    
    static func fetchEvents() {
        if let path = Bundle.main.path(forResource: "event", ofType: "json") {
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            do {
                if let news = try jsonDecoder.decode([Event].self, from: data) as [Event]? {
                    events = news
                }
            } catch {
                print("Unexpected error: \(error).")
            }
        }
    }
}
