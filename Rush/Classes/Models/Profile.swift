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
    var password            : String = ""
    var phoneNumber         : String = ""
    var countryCode         : String = ""
    
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
    }



}
