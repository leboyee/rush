//
//  EnterUserNameViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension EnterUserNameViewController {
    
    
    
}

//MARK: - Manage Interator or API's Calling
extension EnterUserNameViewController {
    
    func updateProfileAPI() {
        
        let param = [kFirst_name: firstNameTextField.text ?? "",
                     KLast_name: lastNameTextField.text ?? ""] as [String : Any]
        
        Utils.showSpinner()
        ServiceManager.shared.updateProfile(params: param) {
            [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let self_ = self else { return }
            if data != nil {
                self_.profileUpdateSuccess()
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }}
