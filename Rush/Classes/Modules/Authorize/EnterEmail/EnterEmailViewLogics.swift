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


//MARK: - Manage Interator or API's Calling
extension EnterEmailViewConteroller {
    
    func checkUserAvailable() {
        Utils.showSpinner()
        ServiceManager.shared.checkEmail(params: [Keys.email: emailTextField.text ?? ""]) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            
            guard let unsafe = self else { return }
            if data != nil {
                if (data![Keys.isEmailExist] as? Bool) == true {
                    if unsafe.loginType == .register {
                        Utils.alert(message: "Email already register.")
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
    
}
