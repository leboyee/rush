//
//  InstaWebViewViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 13/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension InstaWebViewViewController {
    
}

// MARK: - Manage Interator or API's Calling
extension InstaWebViewViewController {
    func uploadAccesstokenInsta(token: String) {
        
        let param = [Keys.instagramToken: token]  as [String: Any]
        Utils.showSpinner()
        ServiceManager.shared.instagramConnect(params: param) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if data != nil {
                unsafe.tokenSuccess()
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
