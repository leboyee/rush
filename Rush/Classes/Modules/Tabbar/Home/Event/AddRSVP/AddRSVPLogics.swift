//
//  CreateEventLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

extension AddRSVPViewController {
        
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return rsvpArray.count
    }
    
    func fillRsvpCell(_ cell: RSVPCell, _ indexPath: IndexPath) {
        cell.setup(isHideClearButton: rsvpArray.count == (indexPath.row + 1) ? true : false)
        cell.setup(titleText: "RSVP #\(indexPath.row + 1)")
        cell.setup(dataTextViewText: rsvpArray[indexPath.row])
        cell.setup(isEmpty: rsvpArray[indexPath.row].isEmpty)
        cell.textDidChanged = {  [weak self] (text) in
            guard let unself = self else { return }
            unself.rsvpArray[indexPath.row] = text
            unself.validateAllFields()
        }
        
        cell.textDidEndEditing = { [weak self] (text) in
            guard let unself = self else { return }
            var txt = text
            if txt.last == "\n" {
                txt = String(txt.dropLast())
            }
            if text.isNotEmpty {
               
            }
            unself.validateAllFields()
        }
        
        cell.clearButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            unself.validateAllFields()
        }
    }
    
}

// MARK: - Other functions
extension AddRSVPViewController {
    
    func validateAllFields() {
       
    }
}
