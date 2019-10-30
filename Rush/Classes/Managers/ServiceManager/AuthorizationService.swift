//
//  AuthorizationService.swift
//  Rush
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
    func login(params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.login(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processLoginResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    /*
     * we check that if user already register with same email
     */
    func checkEmail(params: [String: Any], closer: @escaping (_ data: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.checkEmail(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
    
    func restorePassword(params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
          NetworkManager.shared.restorePassword(params: params) { [weak self] (data, error, code) in
              guard let unsafe = self else { return }
            unsafe.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
                        
          }
      }
    
    func verifyCurrentPassword(params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
           NetworkManager.shared.verifyPassword(params: params) { [weak self] (data, error, code) in
               guard let unsafe = self else { return }
               unsafe.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                   closer(status, errorMessage)
               })
           }
       }
    
    func changePassword(params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.changePassword(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    func restoreNewPassword(params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.restoreNewPassword(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    /*
     * Get Phone token For Verify user
     */
    func authPhone(params: [String: Any], closer: @escaping(_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.authPhone(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }

    /*
     *
     */
    func singup(params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.signup(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processLoginResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    func logout(closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.logout { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    func phonetkn(params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.phonetkn(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processLoginResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    /*
     *  This api is used to resend code as well as change phone number too.
     */
    func resendSMS(params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.resendSMS(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    /*
     *
     */
    // MARK: - Update Push Token
    func updatePushToken(closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.updatePushToken(params: [:]) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }

    // MARK: - Profile
    func getProfile(params: [String: Any], closer: @escaping (_ user: User?, _ errorMessage: String?) -> Void) {
        if Authorization.shared.authorized {
            NetworkManager.shared.getProfile(params: params) { [weak self] (data, error, code) in
                guard let unsafe = self else { return }
                unsafe.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                    //Only if self profile is called and at that time param count is always zero
                    if let object = data?[Keys.user] as? [String: Any] {
                       if params.count == 0 {
                          Authorization.shared.updateUserData(data: object)
                       }
                       let user: User? = unsafe.decodeObject(fromData: object)
                       closer(user, errorMessage)
                    } else {
                       closer(nil, errorMessage)
                    }
                })
            }
        } else {
            closer(nil, Message.tryAgainErrorMessage)
        }
    }
    
    func updateProfile(params: [String: Any], closer: @escaping (_ data: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.updateProfile(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                if let user = data?["user"] as? [String: Any] {
                    Authorization.shared.updateUserData(data: user)
                }
                closer(data, errorMessage)
            })
        }
    }
    
    func uploadUserProfileImage(params: [String: Any], closer: @escaping (_ data: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.uploadUserProfileImage(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                if let user = data?["user"] as? [String: Any] {
                    Authorization.shared.updateUserData(data: user)
                }
                closer(data, errorMessage)
            })
        }
    }
    
    func instagramConnect(params: [String: Any], closer: @escaping (_ data: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.instagramConnect(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
    
    func instagramDisconnect(closer: @escaping (_ data: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.instagramDisconnect { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }

    }
    
    func getUniversityList(params: [String: Any], closer: @escaping (_ university: [University]?, _ errorMessage: String?) -> Void) {
           NetworkManager.shared.getUniversity(params: params) { [weak self] (data, error, code) in
               guard let unsafe = self else { return }
            unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (university, _, errorMessage) in
                closer(university, errorMessage)
            })

           }
       }
    
    func getUniversityListWithSession(params: [String: Any], closer: @escaping (_ university: [University]?, _ errorMessage: String?) -> Void) -> URLSessionDataTask? {
             NetworkManager.shared.getUniversityWithSession(params: params) { [weak self] (data, error, code) in
                 guard let unsafe = self else { return }
              unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (university, _, errorMessage) in
                  closer(university, errorMessage)
              })

             }
         }


    func fetchPeopleList(params: [String: Any], closer: @escaping (_ params: [User]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getPeopleList(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (friends, _, errorMessage) in
                closer(friends, errorMessage)
            })
        }
    }
    // MARK: - Major Minor
    func getMajorList(params: [String: Any], closer: @escaping (_ data: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getMajorList(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
    
    func getMinorList(params: [String: Any], closer: @escaping (_ data: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getMinorList(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
    
    func getInterestList(params: [String: Any], closer: @escaping (_ interest: [Interest]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getInterestList(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (interest, _, errorMessage) in
                               closer(interest, errorMessage)
                          
            })
        }
    }
    
    func getImageList(params: [String: Any], closer: @escaping (_ data: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getImageList(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
    
    func getClassCategory(params: [String: Any], closer: @escaping (_ data: [Class]?, _ errorMessage: String?) -> Void) {
          NetworkManager.shared.getClassCategory(params: params) { [weak self] (data, error, code) in
              guard let unsafe = self else { return }
              unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (data, _, errorMessage) in
                  closer(data, errorMessage)
              })
          }
      }
    
    func getSubClass(classId: String, params: [String: Any], closer: @escaping (_ data: [SubClass]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getSubClass(classId: classId, params: params) { [weak self] (data, error, code) in
               guard let unsafe = self else { return }
               unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (data, _, errorMessage) in
                   closer(data, errorMessage)
               })
           }
       }
    
    
      func inviteContactList(params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
          NetworkManager.shared.inviteContact(params: params) { [weak self] (data, error, code) in
              guard let uwself = self else { return }
              uwself.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                  closer(status, errorMessage)
              })
          }
      }
      
    
    /*
    // MARK: - Profile
    func updateProfile(params : [String: Any], closer: @escaping (_ data: [String: Any]?, _ errorMessage: String?) -> Void) {
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
    
}
