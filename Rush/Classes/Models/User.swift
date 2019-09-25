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
    var socialId: String?
    var password: String?
    var educationLevel: String?
    var educationYear: String?
    var majors: [String]?
    var minors: [String]?
    //var classes: [Classes]?
    var interest: [String]?
    var photo: Image?
    var images: [Image]?
    var university: String?
    var birthDate: String?
    var gender: String?
    var relationship: String?
    var hometown: String?
    var isDarkMode: Int = 0
    var whoCanMessage: String?
    var whoCanInvite: String?
    var isNotifyOn: Bool = false
    var isEventNotify: Bool = false
    var isClassNotify: Bool = false
    var isClubNotify: Bool = false
    var latitude: String?
    var longitude: String?
    var createdAt: String?
    var updatedAt: String?
    var lastLoginTime: String?
    var status: Int = 0
    var instaUserName: String?
    var instaToken: String?

    var name: String {
        return (firstName ?? "") + " " + (lastName ?? "")
    }
    var userId: String {
        return id ?? "0"
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case id = "_id"
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
        case majors = "u_edu_majors"
        case minors = "u_edu_minors"
        case interest = "u_interests"
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
        case isClubNotify = "u_is_club_notify"
        case latitude = "u_latitude"
        case longitude = "u_longitude"
        case createdAt = "u_created_at"
        case updatedAt = "u_updated_at"
        case lastLoginTime = "last_login_time"
        case status = "u_status"
        case instaToken = "insta_token"
        case instaUserName = "insta_username"
        //        case name
        //var classes: [Classes]? u_edu_classes,u_university

    }
    
    init() {
        
    }
    
}

/*{"errors":[],"message":"Success","data":{"user":{"_id":"5d4a7d91392776515c7df196","first_name":"Kamal","last_name":"Mittal","email":"km@messapps.com","u_type":2,"country_code":"91","phone":"9409570520","u_edu_level":"Alumni","u_edu_year":"","u_edu_majors":["Mythology"],"u_edu_minors":["Government/Political Science"],"u_edu_classes":[],"u_interests":[],"u_university":"","u_birth_date":"","u_gender":"","u_relationship":"","u_hometown":"","u_is_dark_mode":"0","u_who_can_message":"Only friends","u_who_can_invite":"Friends and their friends","u_is_notify_on":"1","u_is_event_notify":false,"u_is_club_notify":false,"u_is_class_notify":true,"u_latitude":"","u_longitude":"","u_status":1,"u_created_at":"2019-08-07 07:28:17","u_updated_at":"2019-09-24 12:54:21","last_login_time":"2019-09-24 12:54:21","u_photo":"{\"main\":{\"url\":\"https:\\/\\/rush-app.s3.us-east-2.amazonaws.com\\/user\\/5d4a7d91392776515c7df196\\/profile\\/CQ1hVZ1eJfMTE7Vp_1565162929.jpg\",\"width\":2304,\"height\":2304},\"thumb\":{\"url\":\"https:\\/\\/rush-app.s3.us-east-2.amazonaws.com\\/user\\/5d4a7d91392776515c7df196\\/profile\\/thumb_CQ1hVZ1eJfMTE7Vp_1565162929.jpg\",\"width\":300,\"height\":300}}","insta_token":"","insta_username":""},"images":[]}}
 */
