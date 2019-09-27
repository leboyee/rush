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
        count += (user?.isNotifyOn ?? 1) == 1 ? list.count : 0
        return count
    }
    
    func fillCell(_ cell: CheckMarkCell, _ indexPath: IndexPath) {
        let index = indexPath.row - 1
        guard let user = user else { return }
        cell.set(title: list[index])
        switch index {
        case 0:
            cell.set(isCheckBoxShow: user.isEventNotify == 1 ? true : false)
        case 1:
            cell.set(isCheckBoxShow: user.isClubNotify == 1 ? true : false)
        case 2:
            cell.set(isCheckBoxShow: user.isClassNotify == 1 ? true : false)
        default:
            break
        }
    }
    
    func fillSwitchCell(_ cell: SwitchCell, _ indexPath: IndexPath) {
        
        cell.set(title: Text.recieveNotifications)
        cell.set(isOn: user?.isNotifyOn == 1 ? true : false)
        cell.switchEvent = {  [weak self] (isOn) in
            guard let unsefe = self else { return }
            let params = [Keys.uIsNotifyOn: isOn ? 1 : 0]
            unsefe.updateUserProfile(params: params)
        }
    }
    
    func selectedRow(_ indexPath: IndexPath) {
        
        guard indexPath.row != 0 else { return }
        
        let index = indexPath.row - 1
        var params = [String: Any]()
        switch index {
        case 0:
            params[Keys.uIsEventNotify] = user?.isEventNotify == 1 ? 0 : 1
        case 1:
            params[Keys.uIsClubNotify] = user?.isClubNotify == 1 ? 0 : 1
        case 2:
            params[Keys.uIsClassNotify] = user?.isClassNotify == 1 ? 0 : 1
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
        ServiceManager.shared.updateProfile(params: params) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let unsefe = self else { return }
            if data != nil {
                unsefe.user = Authorization.shared.profile
                /// Reload Cells
                unsefe.tableView.reloadData()
            } else if let message = errorMessage {
                unsefe.showMessage(message: message)
            }
        }
    }
}
