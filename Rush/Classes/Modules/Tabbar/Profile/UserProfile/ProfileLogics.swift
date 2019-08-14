//
//  ProfileLogics.swift
//  Rush
//
//  Created by kamal on 14/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ProfileViewController {
    
    func sectionCount() -> Int {
        return 1
    }
    
    func sectionHeight(_ section: Int) -> CGFloat {
        return section == 3 ? CGFloat.leastNormalMagnitude : 47.0
    }
    
    func cellCount(_ section: Int) -> Int {
        
        var count = 10
//        switch section {
//        case 0, 1, 2:
//            count = 2
//        case 3:
//            count = 1
//        default:
//            count = 0
//        }
        return count
    }
    
    func fillNotificationCell(_ cell: NotificationCell, _ indexPath: IndexPath) {
        
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        header.setup(isDetailArrowHide: false)
        switch section {
        case 0:
            header.setup(title: Text.images)
        case 1:
            header.setup(title: Text.friends)
        case 2:
            header.setup(title: Text.interests)
        case 3:
            header.setup(title: Text.notifications)
        default:
            header.setup(title: "")
        }
    }
    
    func selectedRow(_ indexPath: IndexPath) {
        
    }
}
