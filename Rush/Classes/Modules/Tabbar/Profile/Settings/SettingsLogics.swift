//
//  Rush
//
//  Created by kamal on 08/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension SettingsViewController {
    
    func sectionCount() -> Int {
        return 4
    }
    
    func sectionHeight(_ section: Int) -> CGFloat {
        return section == 3 ? CGFloat.leastNormalMagnitude : 47.0
    }
    
    func cellCount(_ section: Int) -> Int {
        
        var count = 0
        switch section {
        case 0, 2:
            count = 2
        case 1:
            count = 1 /// Made it 1 because we does not need dark mode in that app so in next version, we will make it 2.
        case 3:
            count = 1
        default:
            count = 0
        }
        return count
    }
    
    func fillCell(_ cell: SettingsInfoCell, _ indexPath: IndexPath) {
        cell.set(isHideRightButton: true)
        cell.set(isHideArrow: true)
        let profile = Authorization.shared.profile
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.set(title: Text.email)
                cell.set(detail: profile?.email ?? "")
            case 1:
                cell.set(title: Text.password)
                cell.set(detail: "••••••••••••")
                cell.set(isHideRightButton: false)
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.set(title: Text.notifications)
                cell.set(isHideArrow: false)
                cell.set(detail: "Events, clubs and classes")
                if user?.isNotifyOn == 0 {
                    cell.set(detail: "Off")
                } else {
                    
                    if let isEvent = user?.isEventNotify ,
                       let isClub = user?.isClubNotify,
                       let isClass = user?.isClassNotify {
                        var text = ""
                        if isEvent == 1 {
                            text = "Events"
                        }
                        
                        if isClub == 1 {
                            if text.isEmpty {
                               text = "Clubs"
                            } else {
                                text += (", " + "Clubs")
                            }
                        }
                        
                        if isClass == 1 {
                            if text.isEmpty {
                                text = "Classes"
                            } else {
                                text += (", " + "Classes")
                            }
                        }
                        cell.set(detail: text.capitalized)
                    }
                }
            case 1:
                cell.set(title: Text.darkMode)
            default:
                break
            }
        case 2:
            cell.set(isHideArrow: false)
            switch indexPath.row {
            case 0:
                cell.set(title: Text.whoCanInviteMe)
                cell.set(detail: user?.whoCanInvite ?? "")

            case 1:
                cell.set(title: Text.whoCanMessageMe)
                cell.set(detail: user?.whoCanMessage ?? "")
            default:
                break
            }
            
        default:
            break
        }
        
        cell.rightEvent = { () in
            //Utils.notReadyAlert()
            self.performSegue(withIdentifier: Segues.changePasswordSegue, sender: self)
        }
    }
    
    func fillInstagramCell(_ cell: InstagramCell, _ indexPath: IndexPath) {
        
        if let token = Authorization.shared.profile?.instaToken, token.isNotEmpty {
            let name = Authorization.shared.profile?.instaUserName ?? ""
            cell.set(instagramStatus: true, user: name)
        } else {
            cell.set(instagramStatus: false, user: "")
        }
        
        cell.instagramEvent = { [weak self] () in
            guard let unsefe = self else { return }
            if let token = Authorization.shared.profile?.instaToken, token.isNotEmpty {
                unsefe.showInstagramDisconnect()
            } else {
                /// connect with instagram
                unsefe.showInstagramConnect()
            }
        }
        
    }
    
    func fillSwitchCell(_ cell: SwitchCell, _ indexPath: IndexPath) {
        
        cell.set(isOn: isDarkModeOn)
        cell.switchEvent = {  [weak self] (isOn) in
            guard let unself = self else { return }
            unself.updateUserProfile(params: [Keys.uIsDarkMode: isOn ? 1 : 0])
        }
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(isDetailArrowHide: true)
        switch section {
        case 0:
            header.setup(title: Text.personal)
        case 1:
            header.setup(title: Text.general)
        case 2:
            header.setup(title: Text.privacy)
        default:
            header.setup(title: "")
        }
    }
    
    func selectedRow(_ indexPath: IndexPath) {
        
        if indexPath.section == 2, indexPath.row == 0 {
            showPrivacyInvite()
        } else if indexPath.section == 2, indexPath.row == 1 {
            showPrivacyMessage()
        } else if indexPath.section == 1, indexPath.row == 0 {
            showNotifications()
        }
    }
}

// MARK: - Other function
extension SettingsViewController {
}

// MARK: - API's
extension SettingsViewController {
    
    private func updateUserProfile(params: [String: Any]) {
        Utils.showSpinner()
        ServiceManager.shared.updateProfile(params: params) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let unself = self else { return }
            if data != nil {
                unself.user = Authorization.shared.profile
                /// Update Application Theme
                ThemeManager.shared.loadTheme()
            } else if let message = errorMessage {
                unself.showMessage(message: message)
            }
            
            /// Reload Cells
            unself.tableView.reloadData()
        }
    }
}
