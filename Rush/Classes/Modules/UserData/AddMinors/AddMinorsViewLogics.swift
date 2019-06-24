//
//  AddMinorsViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension AddMinorsViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
            return 56
    }
    
    func cellCount(_ section: Int) -> Int {
        return Utils.chooseYearArray().count
    }
    
    func fillAddMajorCell(_ cell: AddMajorsCell, _ indexPath: IndexPath) {
        cell.setup(title:Utils.chooseYearArray()[indexPath.row])
        cell.setup(isSelected: selectedArray.contains(indexPath.row))
    }
}

//MARK: - Manage Interator or API's Calling
extension AddMinorsViewController {
    
}
