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
        cell.setup(isHideClearButton: indexPath.row != 0 ? false : rsvpArray.first?.isEmpty ?? true)
        cell.setup(titleText: "RSVP #\(indexPath.row + 1)")
        cell.setup(dataTextViewText: rsvpArray[indexPath.row])
        cell.setup(isEmpty: rsvpArray[indexPath.row].isEmpty)
        cell.textDidChanged = {  [weak self] (text) in
            guard let unself = self else { return }
            unself.rsvpArray[indexPath.row] = text
            unself.validateAllFields()
            cell.setup(isHideClearButton: text.isEmpty)
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
            if indexPath.row == 0 {
                if unself.rsvpArray.count > 1 {
                    unself.rsvpArray.remove(at: indexPath.row)
                    unself.tableView.reloadData()
                } else {
                    unself.rsvpArray.remove(at: indexPath.row)
                    cell.dataTextView.text = ""
                    cell.dataTextView.resignFirstResponder()
                }
            } else {
                unself.rsvpArray.remove(at: indexPath.row)
                unself.tableView.reloadData()
            }
            unself.validateAllFields()
        }
        
        cell.updateTableView = { [weak self] (textView) in
                guard let unsafe = self else { return }
            let startHeight = textView.frame.size.height
            var calcHeight = textView.sizeThatFits(textView.frame.size).height
            if calcHeight == startHeight && textView.text.isEmpty {
                calcHeight += 1
            }
            if startHeight != calcHeight {
                // Disable sanimations
                UIView.setAnimationsEnabled(false)
                unsafe.tableView.beginUpdates()
                unsafe.tableView.endUpdates()
                // Enable animations
                UIView.setAnimationsEnabled(true)
            }
        }
    }
    
}

// MARK: - Other functions
extension AddRSVPViewController {
    
    func validateAllFields() {
        let firstRSVP = rsvpArray.first
        self.saveButton.setRsvpSaveButton(isEnable: firstRSVP?.isEmpty == true ? false : true)
    }
    
    func addNewRSVP() {
        let lastRSVP = rsvpArray.last
        if lastRSVP?.isEmpty == false {
            rsvpArray.append("")
            tableView.reloadData()
        }
    }
    
}
