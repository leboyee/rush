//
//  User.swift
//  Rush
//
//  Created by ideveloper on 28/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class User: Decodable {

    var id: String = ""
    var first_name: String = ""
    var last_name: String = ""
    var email: String = ""
    var u_type: Int = 0
    var country_code: String = ""
    var phone: String = ""
    var u_edu_level: String = ""
    var u_edu_year: String = ""
    var u_edu_majors: [String: Any]?
    var u_edu_minors: [String: Any]?
    var u_edu_classes: [String: Any]?
    var u_interests: [String: Any]?
    var u_university: String = ""
    var u_birth_date: String = ""
    var u_gender: String = ""
    var u_relationship: String = ""
    var u_hometown: String = ""
    var u_is_dark_mode: Int = 0
    var u_who_can_message: String = ""
    var u_who_can_invite: String = ""
    var u_is_notify_on: Int = 0
    var u_is_event_notify: Int = 0
    var u_is_class_notify: Int = 0
    var u_latitude: String = ""
    var u_longitude: String = ""
    var u_created_at: String = ""
    var u_updated_at: String = ""
    var last_login_time: String = ""
    var u_status: Int = 0
    
    private enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case first_name
        case last_name
        case email
        case u_type
        case country_code
        case phone
        case u_edu_level
        case u_edu_year
        case u_edu_majors
        case u_edu_minors
        case u_edu_classes
        case u_interests
        case u_university
        case u_birth_date
        case u_gender
        case u_relationship
        case u_hometown
        case u_is_dark_mode
        case u_who_can_message
        case u_who_can_invite
        case u_is_notify_on
        case u_is_event_notify
        case u_is_class_notify
        case u_latitude
        case u_longitude
        case u_created_at
        case u_updated_at
        case last_login_time
        case u_status
    }
    
    init() {
    }
    
    required init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        id = (try? container?.decode(String.self, forKey: .id)) ?? ""
        first_name = (try? container?.decode(String.self, forKey: .first_name)) ?? ""
        last_name = (try? container?.decode(String.self, forKey: .last_name)) ?? ""
        email = (try? container?.decode(String.self, forKey: .email)) ?? ""
        u_type = (try? container?.decode(Int.self, forKey: .u_type)) ?? 0
        country_code = (try? container?.decode(String.self, forKey: .country_code)) ?? ""
        phone = (try? container?.decode(String.self, forKey: .phone)) ?? ""
        u_edu_level = (try? container?.decode(String.self, forKey: .u_edu_level)) ?? ""
        u_edu_year = (try? container?.decode(String.self, forKey: .u_edu_year)) ?? ""
        //u_edu_majors = (try? container?.decode(String.self, forKey: .u_edu_majors)) ?? ""
        //u_edu_minors = (try? container?.decode(String.self, forKey: .u_edu_minors)) ?? ""
        //u_edu_classes = (try? container?.decode(String.self, forKey: .u_edu_classes)) ?? ""
        //u_interests = (try? container?.decode(String.self, forKey: .u_interests)) ?? ""
        u_university = (try? container?.decode(String.self, forKey: .u_university)) ?? ""
        u_birth_date = (try? container?.decode(String.self, forKey: .u_birth_date)) ?? ""
        u_gender = (try? container?.decode(String.self, forKey: .u_gender)) ?? ""
        u_relationship = (try? container?.decode(String.self, forKey: .u_relationship)) ?? ""
        u_hometown = (try? container?.decode(String.self, forKey: .u_hometown)) ?? ""
        u_is_dark_mode = (try? container?.decode(Int.self, forKey: .u_is_dark_mode)) ?? 0
        u_who_can_message = (try? container?.decode(String.self, forKey: .u_who_can_message)) ?? ""
        u_who_can_invite = (try? container?.decode(String.self, forKey: .u_who_can_invite)) ?? ""
        u_is_notify_on = (try? container?.decode(Int.self, forKey: .u_is_notify_on)) ?? 0
        u_is_event_notify = (try? container?.decode(Int.self, forKey: .u_is_event_notify)) ?? 0
        u_is_class_notify = (try? container?.decode(Int.self, forKey: .u_is_class_notify)) ?? 0
        u_latitude = (try? container?.decode(String.self, forKey: .u_latitude)) ?? ""
        u_longitude = (try? container?.decode(String.self, forKey: .u_longitude)) ?? ""
        u_created_at = (try? container?.decode(String.self, forKey: .u_created_at)) ?? ""
        u_updated_at = (try? container?.decode(String.self, forKey: .u_updated_at)) ?? ""
        last_login_time = (try? container?.decode(String.self, forKey: .last_login_time)) ?? ""
        u_status = (try? container?.decode(Int.self, forKey: .u_status)) ?? 0
    }
}
