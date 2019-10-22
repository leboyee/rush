//
//  NotificationItem.swift
//  Rush
//
//  Created by kamal on 03/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class NotificationItem: Codable {
    var id: Int64 = 0
    var ntType: NotificationType = .none
    var ntText: String = ""
    var generatedBy: User?
    var friend: [Friend]?
    var event: [Event]?
    var club: [Club]?
    var classObject: [SubClass]?
    var post: [Post]?
    var classGroupId: Int64 = 0

    private enum CodingKeys: String, CodingKey {
        case id = "nt_id"
        case ntType = "nt_type"
        case ntText = "nt_text"
        case generatedBy = "generated_by"
        case friend = "friend"
        case event = "event"
        case club = "club"
        case classObject = "classes"
        case post = "post"
        case classGroupId = "nt_class_grp_id"
    }
}
