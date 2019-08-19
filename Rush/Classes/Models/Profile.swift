//
//  Profile.swift
//  PaidMeals
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//


import UIKit

class Profile: NSObject {

    var userId              : String = ""
    var phone               : String = ""
    var socialId            : String = ""
    var email                : String = ""
    var name                : String {
        return firstName + " " + lastName
    }
    var firstName: String = ""
    var lastName: String = ""
    var password: String = ""
    var countryCode: String = ""
    var educationLevel      : String = ""
    var educationYear      : String = ""
    var majors = [String]()
    var minors = [String]()
    var classes = [Classes]()
    var interest = [String]()
    var university: String = ""
    var birthDate: String = ""
    var gender: String = ""
    var relationShip: String = ""
    var homeTown: String = ""
    var photo: Image?
    var images: [Image]?

    /// Added by Kamal for Rush
    var isDarkMode: Bool = false
    var isNotificationOn: Bool = true
    var isEventNotificationOn: Bool = true
    var isClubNotificationOn: Bool = true
    var isClassNotificationOn: Bool = true
    var whoCanMessageYou: String = ""
    var whoCanInviteYou: String = ""
    
    init(data : [String : Any]) {
        super.init()
        setData(data: data)
    }

    override init() {
        super.init()
    }

    //MARK: - Private Functions
    func setData(data : [String : Any]) {
        if let value = data["_id"] as? String {
            userId = value
        }

        if let value = data["social_id"] as? String {
            socialId = value
        }

        if let value = data["phone"] as? String {
            phone = value
        } else if let value = data["phone"] as? Int {
            phone = "\(value)"
        }
        
        if let value = data["first_name"] as? String {
            firstName = value
        }
        
        if let value = data["last_name"] as? String {
            lastName = value
        }
        
        if let value = data["country_code"] as? Int {
            countryCode = "\(value)"
        }
        
        if let value = data["u_birth_date"] as? String {
            birthDate = value
        }
        
        if let value = data["u_gender"] as? String {
            gender = value
        }
        
        if let value = data["u_relationship"] as? String {
            relationShip = value
        }
        
        if let value = data["u_hometown"] as? String {
            homeTown = value
        }
        
        /// Added by Kamal for Rush
        
        if let value = data["u_photo"] as? String {
            photo = Image(json: value)
        }
        
        isDarkMode = false
        if let value = data[Keys.u_is_dark_mode] as? Int {
            isDarkMode = value == 1 ? true : false
        } else if let value = data[Keys.u_is_dark_mode] as? String {
            isDarkMode = value == "1" ? true : false
        }
        /// Update global variable
        isDarkModeOn = isDarkMode
        
        isNotificationOn = true
        if let value = data[Keys.u_is_notify_on] as? Int {
            isNotificationOn = value == 1 ? true : false
        } else if let value = data[Keys.u_is_notify_on] as? String {
            isNotificationOn = value == "1" ? true : false
        }
        
        isEventNotificationOn = true
        if let value = data[Keys.u_is_event_notify] as? Int {
            isEventNotificationOn = value == 1 ? true : false
        } else if let value = data[Keys.u_is_event_notify] as? String {
            isEventNotificationOn = value == "1" ? true : false
        }
        
        isClubNotificationOn = true
        if let value = data[Keys.u_is_club_notify] as? Int {
            isClubNotificationOn = value == 1 ? true : false
        } else if let value = data[Keys.u_is_club_notify] as? String {
            isClubNotificationOn = value == "1" ? true : false
        }
        
        isClassNotificationOn = true
        if let value = data[Keys.u_is_class_notify] as? Int {
            isClassNotificationOn = value == 1 ? true : false
        } else if let value = data[Keys.u_is_class_notify] as? String {
            isClassNotificationOn = value == "1" ? true : false
        }
        
        
        if let value = data[Keys.u_who_can_message] as? String {
            whoCanMessageYou = value
        }
        
        if let value = data[Keys.u_who_can_invite] as? String {
            whoCanInviteYou = value
        }
        
    }
}

