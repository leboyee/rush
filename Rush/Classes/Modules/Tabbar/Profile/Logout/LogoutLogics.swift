//
//  LogoutLogics.swift
//  Rush
//
//  Created by kamal on 12/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension LogoutViewController {

    func logout() {
        logoutAPI()
    }
    
}

// MARK: - API's
extension LogoutViewController {
    
    private func logoutAPI() {
        Utils.showSpinner()
        ServiceManager.shared.logout { (_, _) in
            Utils.hideSpinner()
            DispatchQueue.main.async {
                AppDelegate.shared?.forceLogout()
            }
        }
    }
    
}
