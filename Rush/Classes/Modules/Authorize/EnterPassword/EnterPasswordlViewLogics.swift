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
            [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            print(data)
            guard let self_ = self else { return }
            if data != nil {
                
                //self_.profileUpdateSuccess()
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }}
