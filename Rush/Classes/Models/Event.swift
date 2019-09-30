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
    var title: String = ""
    var desc: String = ""
    var photoJson: String = ""
    var eventType: EventType = .none
    var start: Date?
    var end: Date?
    var created: String = ""
    var address: String?
    var latitude: String?
    var longitude: String?
    var interests: String?
    var creator: User?
    var photo: Image? {
        return photoJson.photo
    }

    private var isChatGroupInEvent: String?
    var isChatGroup: Bool {
        return isChatGroupInEvent == "1" ? true : false
    }

    init() {
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId = "event_user_id"
        case eventType = "event_type"
        case photoJson = "event_photo"
        case title = "event_name"
        case desc = "event_desc"
        case start = "event_start_date"
        case end = "event_end_date"
        case address = "event_address"
        case latitude = "event_latitude"
        case longitude = "event_longitude"
        case created = "event_created_at"
        case creator = "user"
        case isChatGroupInEvent = "event_is_chat_group"
        case interests = "event_interests"
    }
}
