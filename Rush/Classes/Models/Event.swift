//
//  Event.swift
//  Rush
//
//  Created by kamal on 07/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

struct EventAction {
    static let join = "join"
    static let accept = "accept"
    static let reject = "reject"
}

struct RSVPAnswer: Codable {
    var index: Int
    var ans: String
    
     private enum CodingKeys: String, CodingKey {
        case index
        case ans
    }
}

struct EventInvite: Codable {
    var id: Int64 = 0
    var status: Int = -1 // 0 = invited, 1 = joined
    var rsvpAns: [RSVPAnswer]?
    
    private enum CodingKeys: String, CodingKey {
        case id = "event_invite_id"
        case status
        case rsvpAns = "rsvp_ans"
    }
}

class Event: Codable {
    
    var id: Int64 = 0
    var userId: Int64 = 0
    var title: String = ""
    var desc: String = ""
    var eventType: EventType = .none
    var start: Date?
    var end: Date?
    var created: String = ""
    var address: String?
    var latitude: String?
    var longitude: String?
    var interests: [Interest]?
    var creator: User?
    var rsvp: [RSVPQuestion]?
    var eventInvite: [EventInvite]?
    var invitees: [Invitee]?
    var photoJson: String = ""
    private var convertJsonToPhoto: Image?
    var photo: Image? {
       if convertJsonToPhoto == nil {
         convertJsonToPhoto = photoJson.photo
       }
       return convertJsonToPhoto
    }
    
    private var isChatGroupInEvent: Int = 0
    var isChatGroup: Bool {
        return isChatGroupInEvent == 1 ? true : false
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "event_id"
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
        case rsvp = "event_rsvp_list"
        case eventInvite = "my_event_invite"
        case invitees = "invitees"
    }
}

class EventCategory: Codable {
    
    var id: String = ""
    var name: String = ""
    var sortOrder = 0
    
    init() {
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
        case sortOrder = "sort_order"
    }
}
