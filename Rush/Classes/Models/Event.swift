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
    
    var id: Int64
    var date: Date
    var title: String
    var type: String
    var start: Date?
    var end: Date?
    var thumbnil: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case date
        case title
        case type
        case start
        case end
        case thumbnil
    }
}
