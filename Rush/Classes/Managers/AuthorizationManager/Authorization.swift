//
//  AuthorizationManager.swift
//  Rush
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//

import UIKit

class Authorization: NSObject {
    
    static let shared = Authorization()
    
    var session: String?
    var userVerified: Bool = false
    var profile: User?
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
        return Utils.getDataFromUserDefault(kSavedProfile) as? [String: Any]
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
        Utils.removeDataFromUserDefault(kHomeTutorialKey)
        
        Utils.removeDataFromUserDefault(kLastLocation)
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    
    func setDummyDataForLogin() {
        Utils.saveDataToUserDefault("", kSavedSession)
    }
    
    func getUser(data: [String: Any]) -> User {
        let user = self.profileModelResponse(data: data)
        return user
    }

    // MARK: Private
    private func fillUser(data: [String: Any]) {
        self.profile = self.profileModelResponse(data: data)
        isDarkModeOn = self.profile?.isDarkMode == 1 ? true : false
    }
    
    func profileModelResponse(data: [String: Any]) -> User {
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .secondsSince1970
            let decodedObject = try jsonDecoder.decode(User.self, from: JSONSerialization.data(withJSONObject: data, options: []))
            return decodedObject
        } catch let error {
            print("ERROR DECODING: \(error)")
            return User()
        }
    }
}

/*    func profileModelResponse(data: [String: Any], closer: @escaping(_ data: User) -> Void) {
 do {
 let jsonDecoder = JSONDecoder()
 jsonDecoder.dateDecodingStrategy = .secondsSince1970
 let decodedObject = try jsonDecoder.decode(User.self, from: JSONSerialization.data(withJSONObject: data, options: []))
 closer(decodedObject)
 } catch let error {
 print("ERROR DECODING: \(error)")
 closer(User())
 }
 }
 */
