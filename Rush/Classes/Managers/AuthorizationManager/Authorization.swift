//
//  AuthorizationManager.swift
//  PaidMeals
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//


import UIKit

class Authorization: NSObject {
    
    static let shared = Authorization()
    
    var session: String?
    var userVerified : Bool = false
    var profile : Profile?
    var authorized: Bool {
        return session != nil
    }
    
    override init() {
        super.init()
        restore()
    }
    
    func signIn(data: [String: Any], sessionId: String) {
        session = sessionId
        fillUser(data: data)
        
        Utils.saveDataToUserDefault(data, kSavedProfile)
        Utils.saveDataToUserDefault(sessionId, kSavedSession)
    }
    
    func restore() {
        session = Utils.getDataFromUserDefault(kSavedSession) as? String
        if let data = Utils.getDataFromUserDefault(kSavedProfile) as? [String: Any] {
            fillUser(data: data)
        }
    }
    
    func getUserData() -> [String: Any]? {
        return Utils.getDataFromUserDefault(kSavedProfile) as? [String : Any]
    }
    
    func updateUserData(data: [String: Any]) {
        Utils.saveDataToUserDefault(data, kSavedProfile)
        restore()
    }
    
    func signOut() {
        session = nil
        profile = nil
        
        Utils.removeDataFromUserDefault(kSavedProfile)
        Utils.removeDataFromUserDefault(kSavedSession)
        Utils.removeDataFromUserDefault(kPushTokenUpdateOnServer)
        
        Utils.removeDataFromUserDefault(kLastLocation)
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    
    func setDummyDataForLogin() {
        Utils.saveDataToUserDefault("", kSavedSession)
    }
    
    // MARK: Private
    private func fillUser(data: [String : Any]) {
        if profile == nil {
            profile = Profile(data: data)
        } else {
            profile?.setData(data: data)
        }
    }
    
}
