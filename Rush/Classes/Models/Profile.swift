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
    var name                : String = ""
    var firstName                : String = ""
    var lastName                : String = ""
    var password            : String = ""
    var phoneNumber         : String = ""
    var countryCode         : String = ""
    var educationLevel      : String = ""
    var educationYear      : String = ""
    var majors  = [String]()
    var minors  = [String]()
    var classes  = [Classes]()
    var interest  = [String]()
    var university : String = ""
    var birthDate: String = ""
    var gender: String = ""
    var relationShip: String = ""
    var homeTown: String = ""

    var photo               : Image?
    var contributedMeals    : Int = 0
    var distributedMeals    : Int = 0
    var isPrivateOn         : Bool = false
    var isMealNotificationOn: Bool = false
    var latitude            : String?
    var longitude           : String?
    var city                : String?
    var state               : String?
    var leaderboard         : Int = 0

    init(data : [String : Any]) {
        super.init()
        setData(data: data)
    }

    override init() {
        super.init()
    }

    //MARK: - Private Functions
    func setData(data : [String : Any]) {
        if let value = data["user_id"] as? Int64 {
            userId = String(value)
        }

        if let value = data["name"] as? String {
            name = value
        }

        if let value = data["social_id"] as? String {
            socialId = value
        }

        if let value = data["phone"] as? String {
            phone = value
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
        if let value = data["phone"] as? Int {
            phone = "\(value)"
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
        
    }
}

