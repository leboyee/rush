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
        ServiceManager.shared.checkEmail(params: [kEmail: emailTextField.text ?? ""]) {
            [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            
            guard let self_ = self else { return }
            if (data != nil){
                if (data![kIsEmailExist] as? Bool) == true {
                    self_.emailSuccess()
                }
                else {
                    self_.emailErrorHideShow(isHide: false)
                    //Utils.alert(message: Message.emailNotAvailable)
                }
            }
            else {
                Utils.alert(message: errorMessage ?? "Please contact Admin")
            }
            
        }
    }
    
}
