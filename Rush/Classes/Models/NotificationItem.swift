//
//  NotificationItem.swift
//  Rush
//
//  Created by kamal on 03/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class NotificationItem: Codable {
    var id: Int64
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
    }
}
