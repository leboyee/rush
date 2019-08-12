//
//  PrivacySettingsLogics.swift
//  Rush
//
//  Created by kamal on 09/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension PrivacySettingsViewController {
   
    func cellCount(_ section: Int) -> Int {
        return list.count
    }
    
    func fillCell(_ cell: CheckMarkCell, _ indexPath: IndexPath) {
       let value = list[indexPath.row]
       cell.set(title: list[indexPath.row])
        let text = (type == .invitesfrom ? user?.whoCanInviteYou : user?.whoCanMessageYou) ?? ""
        if text.lowercased() == value.lowercased() {
            cell.set(isCheckMarkShow: true)
        } else {
            cell.set(isCheckMarkShow: false)
        }
    }
    
    func selectedRow(_ indexPath: IndexPath) {
        
        let key = type == .invitesfrom ? Keys.u_who_can_invite : Keys.u_who_can_message
        let params = [key: list[indexPath.row]]
        updateUserProfile(params: params)
    }
}


// MARK: - API's
extension PrivacySettingsViewController {
    
    private func updateUserProfile(params: [String: Any]) {
        Utils.showSpinner()
        ServiceManager.shared.updateProfile(params: params) {
            [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let self_ = self else { return }
            if let _ = data {
                self_.user = Authorization.shared.profile
                /// Reload Cells
                self_.tableView.reloadData()
            } else if let message = errorMessage {
                self_.showMessage(message: message)
            }
        }
    }
}
