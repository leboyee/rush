//
//  Club.swift
//  Rush
//
//  Created by ideveloper on 28/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class Club: Codable {

    private var id: Int64 = 0
    private var clubUserId: Int64 = 0
    var clubName: String?
    var clubDesc: String?
    var clubInterests: [Interest]?
    var clubPhoto: String?
    var clubIsChatGroup: Int = 0
    var clubStatus: Int = 0
    var clubCreatedAt: String?
    var clubUpdatedAt: String?
    var user: User?
    var invitees: [Invitee]?
    
    private enum CodingKeys: String, CodingKey {
        case id = "club_id"
        case clubUserId = "club_user_id"
        case clubName = "club_name"
        case clubDesc = "club_desc"
        case clubInterests = "club_interests"
        case clubPhoto = "club_photo"
        case clubIsChatGroup = "club_is_chat_group"
        case clubStatus = "club_status"
        case clubCreatedAt = "club_created_at"
        case clubUpdatedAt = "club_updated_at"
        case user
        case invitees
    }
    var clubUId: String {
        return String(clubUserId)
    }
    var clubId: String {
        return String(id)
    }
    init() {
        // default empty init
    }
}

class ClubCategory: Codable {
    
    var id: String = ""
    var name: String = ""
    
    init() {
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
    }
}
