//
//  EventJoinedPopupLogics.swift
//  Rush
//
//  Created by kamal on 13/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import Foundation
import UIKit

extension EventJoinedPopupViewController {
    func updateReceiveNotification() {
        let params = [Keys.uIsNotifyOn: "1", Keys.uIsEventNotify: "1"]
        updateUserProfile(params: params)
    }
}

// MARK: - API's
extension EventJoinedPopupViewController {
    
    private func updateUserProfile(params: [String: Any]) {
        Utils.showSpinner()
        ServiceManager.shared.updateProfile(params: params) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let unsefe = self else { return }
            if data != nil {
               unsefe.dismiss()
            } else if let message = errorMessage {
                unsefe.showMessage(message: message)
            }
        }
    }
}
