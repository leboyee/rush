//
//  User.swift
//  Rush
//
//  Created by ideveloper on 28/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class User: Codable {

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
    var whoCanInvite: String = ""
    var isNotifyOn: Int = 0
    var isEventNotify: Int = 0
    var isClassNotify: Int = 0
    var latitude: String = ""
    var longitude: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    var lastLoginTime: String = ""
    var status: Int = 0
    var name: String {
        return firstName + " " + lastName
    }
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
        case whoCanInvite = "u_who_can_invite"
        case isNotifyOn = "u_is_notify_on"
        case isEventNotify = "u_is_event_notify"
        case isClassNotify = "u_is_class_notify"
        case latitude = "u_latitude"
        case longitude = "u_longitude"
        case createdAt = "u_created_at"
        case updatedAt = "u_updated_at"
        case lastLoginTime = "last_login_time"
        case status = "u_status"
        case name
    }
    
    init() {
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(id, forKey: .id)
        try? container.encode(firstName, forKey: .firstName)
        try? container.encode(lastName, forKey: .lastName)
        try? container.encode(email, forKey: .email)
        try? container.encode(type, forKey: .type)
        try? container.encode(countryCode, forKey: .countryCode)
        try? container.encode(phone, forKey: .phone)
        try? container.encode(eduLevel, forKey: .eduLevel)
        try? container.encode(eduYear, forKey: .eduYear)
        //eduMajors = (try? container?.decode(String.self, forKey: .eduMajors)
        //eduMinors = (try? container?.decode(String.self, forKey: .eduMinors)
        //eduClasses = (try? container?.decode(String.self, forKey: .eduClasses)
        //interests = (try? container?.decode(String.self, forKey: .interests)
        try? container.encode(university, forKey: .university)
        try? container.encode(birthDate, forKey: .birthDate)
        try? container.encode(gender, forKey: .gender)
        try? container.encode(relationship, forKey: .relationship)
        try? container.encode(hometown, forKey: .hometown)
        try? container.encode(isDarkMode, forKey: .isDarkMode)
        try? container.encode(whoCanMessage, forKey: .whoCanMessage)
        try? container.encode(whoCanInvite, forKey: .whoCanInvite)
        try? container.encode(isNotifyOn, forKey: .isNotifyOn)
        try? container.encode(isEventNotify, forKey: .isEventNotify)
        try? container.encode(isClassNotify, forKey: .isClassNotify)
        try? container.encode(latitude, forKey: .latitude)
        try? container.encode(longitude, forKey: .longitude)
        try? container.encode(createdAt, forKey: .createdAt)
        try? container.encode(updatedAt, forKey: .updatedAt)
        try? container.encode(lastLoginTime, forKey: .lastLoginTime)
        try? container.encode(status, forKey: .status)
    }
    
    required init(from decoder: Decoder) throws {
        
    }
}
