//
//  ServiceManager.swift
//  PaidMeals
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//

import UIKit

class ServiceManager: NSObject {
    static let shared = ServiceManager()
    
    // MARK: - functions
    /*
     *
     */
    func prepareServices() {
         let _ = NetworkManager.getUserAgent()
    }
    
    /*
     *
     */
    func processNoDataResponse(result: Any?, error: Error?, code: Int, closer: @escaping(_ status: Bool, _ errorMessage: String?) -> Void) {
        guard code != 200 else {
            closer(true, nil)
            return
        }
        
        errorHandler(result: result, error: error) { (errorMessage) in
            closer(false, errorMessage)
        }
    }
    
    /*
     *
     */
    func processDataResponse(result: Any?, error: Error?, code: Int, closer: @escaping(_ data: [String: Any]?, _ errorMessage: String?) -> Void) {
        guard code != 200 else {
            guard let resultDict = result as? Dictionary<String, Any> else {
                return
            }
            
            guard let data = resultDict[Keys.data] as? [String : Any] else {
                return
            }
            closer(data, nil)
            return
        }
        
        errorHandler(result: result, error: error) { (errorMessage) in
            closer(nil, errorMessage)
        }
    }
    
    /*
     *
     */
    func processLoginResponse(result: Any?, error: Error?, code: Int, closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        guard code != 200 else {
            guard let resultDict = result as? Dictionary<String, Any> else {
                return
            }
            
            guard let data = resultDict[Keys.data] as? Dictionary<String, Any> else {
                return
            }
            
            guard let user = data[Keys.user] as? [String : Any] else {
                return
            }
            
            guard let session = data[Keys.session] as? String else {
                return
            }
                        
            Authorization.shared.signIn(data: user, sessionId: session)
            
            closer(true, nil)
            return
        }
        
        errorHandler(result: result, error: error) { (errorMessage) in
            closer(false, errorMessage)
        }
    }
    
    /*
     *
     */
    func errorHandler(result: Any?, error: Error?, closer: @escaping (_ errorMessage: String?) -> Void) {
       
        var errorMessage = "Indefinite error"
        defer {
            closer(errorMessage)
        }
        
        guard error == nil else {
            errorMessage = error!.localizedDescription
            return
        }
        
        guard let resultDict = result as? Dictionary<String, Any> else {
            return
        }
        
        guard let message = resultDict["message"] as? String else {
            return
        }
        
        errorMessage = message
    }

}
