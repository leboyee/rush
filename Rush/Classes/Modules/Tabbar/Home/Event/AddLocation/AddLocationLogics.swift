//
//  CreateEventLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

extension AddLocationViewController {
        
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return searchedlocationArray.count
    }
    
    func fillLocationCell(_ cell: AddEventLocationCell, _ indexPath: IndexPath) {
        cell.setup(titleText: "test tile")
    }
}
