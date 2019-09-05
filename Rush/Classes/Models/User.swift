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
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var type: Int = 0
    var countryCode: String = ""
    var phone: String = ""
    var eduLevel: String = ""
    var eduYear: String = ""
    var eduMajors: [String: Any]?
    var eduMinors: [String: Any]?
    var eduClasses: [String: Any]?
    var interests: [String: Any]?
    var university: String = ""
    var birthDate: String = ""
    var gender: String = ""
    var relationship: String = ""
    var hometown: String = ""
    var isDarkMode: Int = 0
    var whoCanMessage: String = ""
    var WhoCanInvite: String = ""
    var isNotifyOn: Int = 0
    var isEventNotify: Int = 0
    var isClassNotify: Int = 0
    var latitude: String = ""
    var longitude: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    var lastLoginTime: String = ""
    var status: Int = 0
    
    private enum CodingKeys: String, CodingKey {
        
        case id = "_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case type = "u_type"
        case countryCode = "country_code"
        case phone
        case eduLevel = "u_edu_level"
        case eduYear = "u_edu_year"
        case eduMajors = "u_edu_majors"
        case eduMinors = "u_edu_minors"
        case eduClasses = "u_edu_classes"
        case interests = "u_interests"
        case university = "u_university"
        case birthDate = "u_birth_date"
        case gender = "u_gender"
        case relationship = "u_relationship"
        case hometown = "u_hometown"
        case isDarkMode = "u_is_dark_mode"
        case whoCanMessage = "u_who_can_message"
        case WhoCanInvite = "u_who_can_invite"
        case isNotifyOn = "u_is_notify_on"
        case isEventNotify = "u_is_event_notify"
        case isClassNotify = "u_is_class_notify"
        case latitude = "u_latitude"
        case longitude = "u_longitude"
        case createdAt = "u_created_at"
        case updatedAt = "u_updated_at"
        case lastLoginTime = "last_login_time"
        case status = "u_status"
    }
    
    init() {
    }
    
    required init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        id = (try? container?.decode(String.self, forKey: .id)) ?? ""
        firstName = (try? container?.decode(String.self, forKey: .firstName)) ?? ""
        lastName = (try? container?.decode(String.self, forKey: .lastName)) ?? ""
        email = (try? container?.decode(String.self, forKey: .email)) ?? ""
        type = (try? container?.decode(Int.self, forKey: .type)) ?? 0
        countryCode = (try? container?.decode(String.self, forKey: .countryCode)) ?? ""
        phone = (try? container?.decode(String.self, forKey: .phone)) ?? ""
        eduLevel = (try? container?.decode(String.self, forKey: .eduLevel)) ?? ""
        eduYear = (try? container?.decode(String.self, forKey: .eduYear)) ?? ""
        //eduMajors = (try? container?.decode(String.self, forKey: .eduMajors)) ?? ""
        //eduMinors = (try? container?.decode(String.self, forKey: .eduMinors)) ?? ""
        //eduClasses = (try? container?.decode(String.self, forKey: .eduClasses)) ?? ""
        //interests = (try? container?.decode(String.self, forKey: .interests)) ?? ""
        university = (try? container?.decode(String.self, forKey: .university)) ?? ""
        birthDate = (try? container?.decode(String.self, forKey: .birthDate)) ?? ""
        gender = (try? container?.decode(String.self, forKey: .gender)) ?? ""
        relationship = (try? container?.decode(String.self, forKey: .relationship)) ?? ""
        hometown = (try? container?.decode(String.self, forKey: .hometown)) ?? ""
        isDarkMode = (try? container?.decode(Int.self, forKey: .isDarkMode)) ?? 0
        whoCanMessage = (try? container?.decode(String.self, forKey: .whoCanMessage)) ?? ""
        WhoCanInvite = (try? container?.decode(String.self, forKey: .WhoCanInvite)) ?? ""
        isNotifyOn = (try? container?.decode(Int.self, forKey: .isNotifyOn)) ?? 0
        isEventNotify = (try? container?.decode(Int.self, forKey: .isEventNotify)) ?? 0
        isClassNotify = (try? container?.decode(Int.self, forKey: .isClassNotify)) ?? 0
        latitude = (try? container?.decode(String.self, forKey: .latitude)) ?? ""
        longitude = (try? container?.decode(String.self, forKey: .longitude)) ?? ""
        createdAt = (try? container?.decode(String.self, forKey: .createdAt)) ?? ""
        updatedAt = (try? container?.decode(String.self, forKey: .updatedAt)) ?? ""
        lastLoginTime = (try? container?.decode(String.self, forKey: .lastLoginTime)) ?? ""
        status = (try? container?.decode(Int.self, forKey: .status)) ?? 0
    }
}
