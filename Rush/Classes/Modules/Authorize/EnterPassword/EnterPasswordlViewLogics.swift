//
//  EnterPasswordlViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension EnterPasswordViewConteroller {
}

// MARK: - Manage Interator or API's Calling
extension EnterPasswordViewConteroller {
    
    func loginApiCalled() {
        let param = [Keys.email: profile.email ?? "",
                     Keys.password: profile.password ?? ""] as [String: Any]
        
        Utils.showSpinner()
        ServiceManager.shared.login(params: param) { [weak self] (status, _) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if status == true {
                if Utils.getDataFromUserDefault(kPushToken) != nil {
                    //API call and when success
                    ServiceManager.shared.updatePushToken(closer: { (status, _) in
                        if status {
                        }
                    })
                }
                unsafe.profileUpdateSuccess()
            } else {
                unsafe.passwordNotSuccess()
                //Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func currentPasswordApi(password: String) {
        let param = [
                     Keys.currentPassword: password] as [String: Any]
        
        Utils.showSpinner()
        ServiceManager.shared.verifyCurrentPassword(params: param) { [weak self] (status, _) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if status == true {
                unsafe.profileUpdateSuccess()
            } else {
                unsafe.passwordNotSuccess()
                //Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func changePasswordApi(currentPassword: String, newPassword: String) {
           let param = [
                        Keys.currentPassword: currentPassword,
                        Keys.newPassword: newPassword] as [String: Any]
           
           Utils.showSpinner()
           ServiceManager.shared.changePassword(params: param) { [weak self] (status, errorMessage) in
               Utils.hideSpinner()
               guard let unsafe = self else { return }
               if status == true {
              
                   unsafe.profileUpdateSuccess()
               } else {
                  // unsafe.passwordNotSuccess()
                   Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
               }
           }
       }
    
    func restorePassword(emailToken: String, newPassword: String) {
        let param = [
            Keys.emailToken: emailToken,
            Keys.newPassword: newPassword] as [String: Any]
        
        Utils.showSpinner()
        ServiceManager.shared.restoreNewPassword(params: param) { [weak self] (status, errorMessage) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if status == true {
                unsafe.profileUpdateSuccess()
            } else {
                // unsafe.passwordNotSuccess()
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func restorePassword(emailText: String) {
             Utils.showSpinner()
             ServiceManager.shared.restorePassword(params: [Keys.email: emailText]) { [weak self] (status, errorMessage) in
                 guard let unsafe = self else { return }
                  Utils.hideSpinner()
                 if status == true {
                    Utils.alert(message: "You will receive an email to your email address \"suresh@gmail.edu\" to restore password.")
                 } else {
                  Utils.hideSpinner()
                     Utils.alert(message: errorMessage ?? "Please contact Admin")
                 }
                 
             }
         }
}
