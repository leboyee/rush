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
    var club_user_id: String = ""
    var club_name: String = ""
    var club_desc: String = ""
    var club_interests: String = ""
    var club_photo: String = ""
    var club_is_chat_group: String = ""
    var club_status: String = ""
    var club_created_at: String = ""
    var club_updated_at: String = ""
    var user: User?
    var invitees: [Invitees]?
    
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case club_user_id
        case club_name
        case club_desc
        case club_interests
        case club_photo
        case club_is_chat_group
        case club_status
        case club_created_at
        case club_updated_at
        case user
        case invitees
    }
    
    init() {
        // default empty init
    }
    
    required init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        id = (try? container?.decode(String.self, forKey: .id)) ?? ""
        club_user_id = (try? container?.decode(String.self, forKey: .club_user_id)) ?? ""
        club_name = (try? container?.decode(String.self, forKey: .club_name)) ?? ""
        club_desc = (try? container?.decode(String.self, forKey: .club_desc)) ?? ""
        club_interests = (try? container?.decode(String.self, forKey: .club_interests)) ?? ""
        club_photo = (try? container?.decode(String.self, forKey: .club_photo)) ?? ""
        club_is_chat_group = (try? container?.decode(String.self, forKey: .club_is_chat_group)) ?? ""
        club_status = (try? container?.decode(String.self, forKey: .club_status)) ?? ""
        club_created_at = (try? container?.decode(String.self, forKey: .club_created_at)) ?? ""
        club_updated_at = (try? container?.decode(String.self, forKey: .club_updated_at)) ?? ""
        user = (try? container?.decode(User.self, forKey: .user))
        invitees = (try? container?.decode([Invitees].self, forKey: .invitees))
    }
}
