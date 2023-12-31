//
//  Club.swift
//  Rush
//
//  Created by ideveloper on 28/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class Club: Codable {
    
    var id: Int64 = 0
    private var clubUserId: Int64 = 0
    var clubName: String?
    var clubDesc: String?
    var clubUniversityId: Int = 0
    var clubTotalJoined: Int = 0
    var clubInterests: [Interest]?
    var clubPhoto: String?
    var clubIsChatGroup: Int = 0
    var clubStatus: Int = 0
    var clubCreatedAt: String?
    var clubUpdatedAt: String?
    var myClubInvite: [MyClubInvitee]?
    var user: User?
    var invitees: [Invitee]?
    var university: [University]?
    private var convertJsonToPhoto: Image?
    
    private enum CodingKeys: String, CodingKey {
        case id = "club_id"
        case clubUserId = "club_user_id"
        case clubName = "club_name"
        case clubDesc = "club_desc"
        case clubUniversityId = "club_university_id"
        case clubInterests = "club_interests"
        case clubPhoto = "club_photo"
        case clubIsChatGroup = "club_is_chat_group"
        case clubStatus = "club_status"
        case clubCreatedAt = "club_created_at"
        case clubUpdatedAt = "club_updated_at"
        case clubTotalJoined = "club_total_joined"
        case myClubInvite = "my_club_invite"
        case user
        case invitees
        case university
    }
    var clubUId: String {
        return String(clubUserId)
    }
    var clubId: String {
        return String(id)
    }
    var photo: Image? {
        if convertJsonToPhoto == nil {
            convertJsonToPhoto = clubPhoto?.photo
        }
        return convertJsonToPhoto
    }
    
    init() {
        // default empty init
    }
}

class ClubCategory: Codable {
    
    private var idP: Int64 = 0
    var name: String = ""
    var clubArray: [Club]?
    
    private enum CodingKeys: String, CodingKey {
        case idP = "interest_id"
        case name = "name"
        case clubArray = "club"
    }
    
    var id: String {
        get {
            return String(idP)
        }
        set(idx) {
            self.id = idx
        }
    }
}

class MyClubInvitee: Codable {

    var id: Int64 = 0
    var clubInviteId: Int64 = 0

    var userId: String {
        return String(id)
    }
    
    private enum CodingKeys: String, CodingKey {
        //case inviteeId = "invite_id"
        case id = "user_id"
        case clubInviteId = "club_invite_id"
    }
    
    init() {
        // default empty init
    }
}
