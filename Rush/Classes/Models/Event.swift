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
    var userId: String = ""
    var type: String = ""
    var date: Date?
    var title: String = ""
    var desc: String = ""
    var photoJson: String = ""
    var eventType: EventType = .none
    var start: Date?
    var end: Date?
    var thumbnil: String?
    var created: String = ""
    var address: Address?
    var owner: Profile?

    init() {
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId = "event_user_id"
        case type = "event_type"
        case photoJson = "event_photo"
        case title = "event_name"
        case date
        case desc = "event_desc"
        case start
        case end
        case thumbnil
        case address
        case created = "event_created_at"
    }
}
