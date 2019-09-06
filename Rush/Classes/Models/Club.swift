//
//  Club.swift
//  Rush
//
//  Created by ideveloper on 28/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class Club: Decodable {

    var id: String = ""
    var clubUserId: String = ""
    var clubName: String = ""
    var clubDesc: String = ""
    var clubInterests: String = ""
    var clubPhoto: String = ""
    var clubIsChatGroup: String = ""
    var clubStatus: String = ""
    var clubCreatedAt: String = ""
    var clubUpdatedAt: String = ""
    var user: User?
    var invitees: [Invitees]?
    
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
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
    
    init() {
        // default empty init
    }
    
    required init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        id = (try? container?.decode(String.self, forKey: .id)) ?? ""
        clubUserId = (try? container?.decode(String.self, forKey: .clubUserId)) ?? ""
        clubName = (try? container?.decode(String.self, forKey: .clubName)) ?? ""
        clubDesc = (try? container?.decode(String.self, forKey: .clubDesc)) ?? ""
        clubInterests = (try? container?.decode(String.self, forKey: .clubInterests)) ?? ""
        clubPhoto = (try? container?.decode(String.self, forKey: .clubPhoto)) ?? ""
        clubIsChatGroup = (try? container?.decode(String.self, forKey: .clubIsChatGroup)) ?? ""
        clubStatus = (try? container?.decode(String.self, forKey: .clubStatus)) ?? ""
        clubCreatedAt = (try? container?.decode(String.self, forKey: .clubCreatedAt)) ?? ""
        clubUpdatedAt = (try? container?.decode(String.self, forKey: .clubUpdatedAt)) ?? ""
        user = (try? container?.decode(User.self, forKey: .user))
        invitees = (try? container?.decode([Invitees].self, forKey: .invitees))
    }
}
