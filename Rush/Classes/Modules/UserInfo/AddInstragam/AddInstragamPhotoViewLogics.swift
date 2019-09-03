//
//  AddInviteViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension AddInstragamPhotoViewController {
    
}



//MARK: - Manage Interator or API's Calling
extension AddInstragamPhotoViewController {
    func uploadAccesstokenInsta(token: String) {
        
        let param = [Keys.instagramToken: token]  as [String : Any]
        Utils.showSpinner()
        ServiceManager.shared.instagramConnect(params: param) {
            [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let self_ = self else { return }
            if data != nil {
                self_.tokenSuccess()
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
