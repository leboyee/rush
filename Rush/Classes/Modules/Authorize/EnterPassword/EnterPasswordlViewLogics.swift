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
                unsafe.profileUpdateSuccess()
            } else {
                unsafe.passwordNotSuccess()
                //Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
