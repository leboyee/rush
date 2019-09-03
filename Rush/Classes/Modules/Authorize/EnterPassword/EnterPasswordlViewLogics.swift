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


//MARK: - Manage Interator or API's Calling
extension EnterPasswordViewConteroller {
    
    func loginApiCalled() {
        
        let param = [kEmail: profile.email,
                     kPassword: profile.password] as [String : Any]
        
        Utils.showSpinner()
        ServiceManager.shared.login(params: param) {
            [weak self] (status, errorMessage) in
            Utils.hideSpinner()
            guard let self_ = self else { return }
            if status == true {
                self_.profileUpdateSuccess()
            } else {
                self_.passwordNotSuccess()
                //Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
