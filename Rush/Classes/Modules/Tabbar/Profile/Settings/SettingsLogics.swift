//
//  MARK: -
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
        case 0, 1, 2:
            count = 2
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
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.set(title: Text.email)
                cell.set(detail: "km@messapps.com")
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
                cell.set(detail: "Everyone")

            case 1:
                cell.set(title: Text.whoCanMessageMe)
                cell.set(detail: "Only friends")

            default:
                break
            }
            
        default:
            break
        }
        
        cell.rightEvent = { [weak self] () in
            guard let _ = self else { return }
            Utils.notReadyAlert()
        }
        
    }
    
    func fillInstagramCell(_ cell: InstagramCell, _ indexPath: IndexPath) {
        
    }
    
    func fillSwitchCell(_ cell: SwitchCell, _ indexPath: IndexPath) {
        
        cell.set(isOn: isDarkModeOn)
        cell.switchEvent = {  [weak self] (isOn) in
            guard let _ = self else { return }
            isDarkModeOn = isOn
            ThemeManager.shared.loadTheme()
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
        
    }
}

//MARK: -Other function
extension SettingsViewController {
    
    
}

//MARK: - API's
extension SettingsViewController {
    
    
}

