//
//  User.swift
//  Rush
//
//  Created by ideveloper on 28/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class User: Codable {
    
    var id: Int64 = 0
    var firstName: String?
    var lastName: String?
    var email: String?
    var type: Int = 0
    var countryCode: String?
    var phone: String?
    var eduLevel: String?
    var eduYear: String?
    var socialId: String?
    var password: String?
    var educationLevel: String?
    var educationYear: String?
    var majors: [Major]?
    var minors: [Minor]?
    var interest: [Interest]?
    var university: [University]?
    var birthDate: String?
    var gender: String?
    var relationship: String?
    var hometown: String?
    var isDarkMode: Int = 0
    var whoCanMessage: String?
    var whoCanInvite: String?
    var isNotifyOn: Int = 1
    var isEventNotify: Int = 1
    var isClassNotify: Int = 1
    var isClubNotify: Int = 1
    var latitude: String?
    var longitude: String?
    var createdAt: String?
    var updatedAt: String?
    var lastLoginTime: String?
    var status: Int = 0
    var instaUserName: String?
    var instaToken: String?
    var totalEvents: Int?
    
    private var photoJson: String?
    private var convertJsonToPhoto: Image?
    var friend: [Friend]?
    
    var photo: Image? {
        if convertJsonToPhoto == nil {
            convertJsonToPhoto = photoJson?.photo
        }
        return convertJsonToPhoto
    }

    var name: String {
        return (firstName ?? "") + " " + (lastName ?? "")
    }
    
    var userId: String {
        return String(id)
    }
    
    var friendTypeStatus: ManageButtonType {
         let isAlreadyFriend: Bool = friend?.first?.friendStatus == 1
        if isAlreadyFriend {
            return .friends
        } else {
            if friend?.first?.friendType == 1 {
                return .requested
            } else if friend?.first?.friendType == 2 {
                return .accept
            } else {
                return .addFriend
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case id = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case type = "u_type"
        case countryCode = "country_code"
        case phone
        case educationLevel = "u_edu_level"
        case educationYear = "u_edu_year"
        case socialId = "social_id"
        case password
        case majors = "user_majors"
        case minors = "user_minors"
        case interest = "user_interests"
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
        case isClubNotify = "u_is_club_notify"
        case latitude = "u_latitude"
        case longitude = "u_longitude"
        case createdAt = "u_created_at"
        case updatedAt = "u_updated_at"
        case lastLoginTime = "last_login_time"
        case status = "u_status"
        case instaToken = "insta_token"
        case instaUserName = "insta_username"
        case photoJson = "u_photo"
        case friend = "friend_data"
        case university = "university"
        //        case name
        //var classes: [Classes]? u_edu_classes,u_university

        case totalEvents = "total_events"
    }
    
    init() {
        
    }
    
}

class MentionedUser: Codable {
    var id: Int64?
    var firstName: String?
    var lastName: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    var name: String {
        return (firstName ?? "") + " " + (lastName ?? "")
    }
}

class Major: Codable {
    
    var id: Int64 = 0
    var majorName: String?
    var userId: Int64 = 0
    
    private enum CodingKeys: String, CodingKey {
        case id = "major_id"
        case majorName = "name"
        case userId = "user_id"
    }
    init() {
         
     }
}

class Minor: Codable {
    var id: Int64 = 0
    var minorName: String?
    var userId: Int64 = 0
    
    private enum CodingKeys: String, CodingKey {
        case id = "minor_id"
        case minorName = "name"
        case userId = "user_id"
    }
    init() {
         
     }
}
