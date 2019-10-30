//
//  EnterEmailViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension EnterEmailViewConteroller {
}

// MARK: - Manage Interator or API's Calling
extension EnterEmailViewConteroller {
    
    func checkUserAvailable() {
        Utils.showSpinner()
        var email = emailTextField.text ?? ""
         //email = email.replacingOccurrences(of: ".edu", with: ".com")

        ServiceManager.shared.checkEmail(params: [Keys.email: email]) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            
            guard let unsafe = self else { return }
            if data != nil {
                if (data![Keys.isEmailExist] as? Bool) == true {
                    if unsafe.loginType == .register {
                        Utils.alert(message: "Email is already in use.")
                    } else {
                         unsafe.emailSuccess()
                    }
                } else {
                    if unsafe.loginType == .register {
                            unsafe.emailSuccess()
                    } else {
                          unsafe.emailErrorHideShow(isHide: false)
                    }
                }
            } else {
                Utils.alert(message: errorMessage ?? "Please contact Admin")
            }
            
        }
    }
    
    func restorePassword() {
           Utils.showSpinner()
        var email = emailTextField.text ?? ""
        // email = email.replacingOccurrences(of: ".edu", with: ".com")
           ServiceManager.shared.restorePassword(params: [Keys.email: email]) { [weak self] (status, errorMessage) in
               guard let unsafe = self else { return }
                Utils.hideSpinner()

               if status == true {
                    unsafe.emailSuccess()
               } else {
                Utils.hideSpinner()
                   Utils.alert(message: errorMessage ?? "Please contact Admin")
               }
               
           }
       }
    
}
