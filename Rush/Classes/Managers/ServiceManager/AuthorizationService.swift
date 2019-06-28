//
//  AuthorizationService.swift
//  PaidMeals
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//


import UIKit

//class AuthorizationService: NSObject {
extension ServiceManager {
    //static let shared = AuthorizationService()
    
    
    /*
     *
     */
    func signInSingup(params : [String : Any], closer: @escaping (_ status: Bool,_ errorMessage: String?) -> Void) {
        NetworkManager.shared.signup(params: params) {
            [weak self] (data, error, code) -> (Void) in
            guard let self_ = self else { return }
            self_.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status,errorMessage)
            })
        }
    }
    
  
    
    func logout(closer: @escaping (_ status: Bool,_ errorMessage: String?) -> Void) {
        NetworkManager.shared.logout(params: [:]) {
            [weak self] (data, error, code) -> (Void) in
            guard let self_ = self else { return }
            self_.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status,errorMessage)
            })
        }
    }
    
    
    func phonetkn(params : [String : Any], closer: @escaping (_ status: Bool,_ errorMessage: String?) -> Void) {
        NetworkManager.shared.phonetkn(params: params) {
            [weak self] (data, error, code) -> (Void) in
            guard let self_ = self else { return }
            self_.processLoginResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status,errorMessage)
            })
        }
    }
    
    /*
     *  This api is used to resend code as well as change phone number too.
     */
    func resendSMS(params : [String : Any], closer: @escaping (_ status: Bool,_ errorMessage: String?) -> Void) {
        NetworkManager.shared.resendSMS(params: params) {
            [weak self] (data, error, code) -> (Void) in
            guard let self_ = self else { return }
            self_.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status,errorMessage)
            })
        }
    }
    
    /*
     *
     */
    //MARK: - Update Push Token
    func updatePushToken(closer: @escaping (_ status: Bool,_ errorMessage: String?) -> Void) {
        NetworkManager.shared.updatePushToken(params: [:]) { [weak self] (data, error, code) -> (Void) in
            guard let self_ = self else { return }
            self_.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    
    /*
    //MARK: - Profile
    func updateProfile(params : [String : Any], closer: @escaping (_ data: [String : Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.updateProfile(params: params) {
            [weak self] (data, error, code) -> (Void) in
            guard let self_ = self else { return }
            self_.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                if var user = data?[Keys.user] as? [String: Any] {
                    //Set Leaderboard value because it is not come when edit profile.
                    if let value = Authorization.shared.profile?.leaderboard, value > 0 {
                        user[Keys.leaderboard] = value
                    }
                    Authorization.shared.updateUserData(data: user)
                }
                closer(data, errorMessage)
            })
        }
    }
 
 */
    /*
    func getProfile(params : [String : Any],closer: @escaping (_ data: [String : Any]?, _ errorMessage: String?) -> Void) {
        if Authorization.shared.authorized {
            NetworkManager.shared.getProfile(params: params) { [weak self] (data, error, code) -> (Void) in
                guard let self_ = self else { return }
                self_.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                    //Only if self profile is called and at that time param count is always zero
                    if params.count == 0, let user = data?[Keys.user] as? [String: Any] {
                        Authorization.shared.updateUserData(data: user)
                    }
                    closer(data, errorMessage)
                })
            }
        } else {
            closer(nil, Message.tryAgainErrorMessage)
        }
    }
    */

    
}
