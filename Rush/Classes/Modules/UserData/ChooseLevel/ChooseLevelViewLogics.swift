//
//  ChooseLevelViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ChooseLevelViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
            return 56
    }
    
    func cellCount(_ section: Int) -> Int {
        return Utils.chooseLevelArray().count
    }
    
    func fillChooseLevelCell(_ cell: ListCell, _ indexPath: IndexPath) {
        cell.setup(title:Utils.chooseLevelArray()[indexPath.row])
        cell.setup(checkMark: selectedIndex == indexPath.row ? true : false)
    }
}

//MARK: - Manage Interator or API's Calling
extension ChooseLevelViewController {
    
}
