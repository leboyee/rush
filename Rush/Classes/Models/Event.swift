//
//  Event.swift
//  Rush
//
//  Created by kamal on 07/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

struct EventGroup {
    var dateString: String
    var events: [Event]
}

class Event: Codable {
    
    var id: String = ""
    var date: Date?
    var title: String = ""
    var desc: String = ""
    var type: String = ""
    var eventType: EventType = .none
    var start: Date?
    var end: Date?
    var thumbnil: String?
    var address: Address?
    var owner: Profile?

    init() {
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case date
        case title
        case desc
        case type
        case start
        case end
        case thumbnil
        case address
    }
}
