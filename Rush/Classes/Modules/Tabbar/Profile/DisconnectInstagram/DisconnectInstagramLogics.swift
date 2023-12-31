//
//  DisconnectInstagramLogics.swift
//  Rush
//
//  Created by kamal on 12/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension DisconnectInstagramViewController {
    
    func disconnect() {
        instagramDisconnect()
    }
}

extension DisconnectInstagramViewController {
    
    private func instagramDisconnect() {
        Utils.showSpinner()
        ServiceManager.shared.instagramDisconnect { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let unsefe = self else { return }
            if let user = data?[Keys.user] as? [String: Any] {
                Authorization.shared.updateUserData(data: user)
                unsefe.dismiss()
            } else if let message = errorMessage {
                unsefe.showMessage(message: message)
            }
        }
    }
}
