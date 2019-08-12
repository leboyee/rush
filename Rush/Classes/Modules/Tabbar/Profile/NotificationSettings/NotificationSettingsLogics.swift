//
//  NotificationSettingsLogics.swift
//  Rush
//
//  Created by kamal on 09/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension NotificationSettingsViewController {
    
    func cellCount(_ section: Int) -> Int {
        var count = 1
        count += (user?.isNotificationOn ?? true) ? list.count : 0
        return count
    }
    
    func fillCell(_ cell: CheckMarkCell, _ indexPath: IndexPath) {
        let index = indexPath.row - 1
        cell.set(title: list[index])
        switch index {
        case 0:
            cell.set(isCheckBoxShow: user?.isEventNotificationOn ?? true)
        case 1:
            cell.set(isCheckBoxShow: user?.isClubNotificationOn ?? true)
        case 2:
            cell.set(isCheckBoxShow: user?.isClassNotificationOn ?? true)
        default:
            break
        }
    }
    
    func fillSwitchCell(_ cell: SwitchCell, _ indexPath: IndexPath) {
        
        cell.set(title: Text.recieveNotifications)
        cell.set(isOn: user?.isNotificationOn ?? true)
        cell.switchEvent = {  [weak self] (isOn) in
            guard let self_ = self else { return }
            let params = [Keys.u_is_notify_on : isOn ? "1" : "0"]
            self_.updateUserProfile(params: params)
        }
    }
    
    func selectedRow(_ indexPath: IndexPath) {
        
        guard indexPath.row != 0 else { return }
        
        let index = indexPath.row - 1
        var params = [String: Any] ()
        switch index {
        case 0:
            params[Keys.u_is_event_notify] = !(user?.isEventNotificationOn ?? true)
        case 1:
            params[Keys.u_is_club_notify] = !(user?.isClubNotificationOn ?? true)
        case 2:
            params[Keys.u_is_class_notify] = !(user?.isClassNotificationOn ?? true)
        default:
            break
        }
        
        guard params.count > 0 else { return }
        updateUserProfile(params: params)
       
    }
}


// MARK: - API's
extension NotificationSettingsViewController {

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
