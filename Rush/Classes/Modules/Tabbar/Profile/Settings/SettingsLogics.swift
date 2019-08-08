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

