//
//  User.swift
//  Rush
//
//  Created by ideveloper on 28/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class User: Codable {
    
    var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var type: Int = 0
    var countryCode: String?
    var phone: String?
    var eduLevel: String?
    var eduYear: String?
    /*
    var eduMajors: String?
    var eduMinors: String?
    var eduClasses: String?
    var interests: String?
    */
    var university: String?
    var birthDate: String?
    var gender: String?
    var relationship: String?
    var hometown: String?
    var isDarkMode: Int = 0
    var whoCanMessage: String?
    var whoCanInvite: String?
    var isNotifyOn: Int = 0
    var isEventNotify: Int = 0
    var isClassNotify: Int = 0
    var latitude: String?
    var longitude: String?
    var createdAt: String?
    var updatedAt: String?
    var lastLoginTime: String?
    var status: Int = 0
    
    var name: String {
        return (firstName ?? "") + " " + (lastName ?? "")
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
        /*
        case eduMajors = "u_edu_majors"
        case eduMinors = "u_edu_minors"
        case eduClasses = "u_edu_classes"
        case interests = "u_interests"
        */
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
        //        case name
    }
    
    init() {
        
    }
}
