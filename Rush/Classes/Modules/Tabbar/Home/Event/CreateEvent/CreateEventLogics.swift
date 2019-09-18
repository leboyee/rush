//
//  CreateEventLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos
import IQKeyboardManagerSwift

extension CreateEventViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        // Navigaiton height + cornerRadius height + changePhotoLabelOrigin
        let total = ((Utils.navigationHeigh*2) + 24 + 216)
        return section == 0 ? total : CGFloat.leastNormalMagnitude
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 8
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        if section == 2 {
            return interestList.count + 1
        } else if section == 3 {
            return peopleList.count + 1
        }
        return 1
    }
    
    func fillTextIconCell(_ cell: TextIconCell, _ indexPath: IndexPath) {
        
        cell.setup(placeholder: "", title: Text.createGroupChat)
        cell.setup(isShowSwitch: true)
        cell.setup(iconImage: "")
        
        cell.switchValueChanged = { (isOn) in
            
        }
    }
    
    func fillDateAndTimeEvent(_ cell: DateAndTimeCell, _ indexPath: IndexPath) {
        
        if indexPath.section == 4 {
            
            cell.setup(dateButtonText: startDate.isEmpty == true ? Date().eventDateFormat(date: Date()) : startDate)
            cell.setup(timeButtonText: startTime.isEmpty == true ? "12 pm" : startTime)
            cell.separatorView.isHidden = true
            cell.dateButtonClickEvent = { () in
                Utils.alert(message: "In Development")
            }
            
            cell.timeButtonClickEvent = { () in
                Utils.alert(message: "In Development")
            }
            
        } else {
            
            cell.setup(dateButtonText: endDate.isEmpty == true ? Date().eventDateFormat(date: Date()) : endDate)
            cell.setup(timeButtonText: endTime.isEmpty == true ? "13 pm" : endTime)
            cell.separatorView.isHidden = false

            cell.dateButtonClickEvent = { () in
                Utils.alert(message: "In Development")
            }
            
            cell.timeButtonClickEvent = { () in
                Utils.alert(message: "In Development")
            }
        }
      
    }
    
    func fillTextViewCell(_ cell: TextViewCell, _ indexPath: IndexPath) {
        
        cell.resetAllField()
        cell.setup(keyboardReturnKeyType: .done)
        if indexPath.section == 0 {
            cell.setup(iconImage: "nameEvent")
            cell.setup(placeholder: Text.nameEvent, text: nameEvent)
            cell.setup(isEnabled: true)
            cell.topConstraintOfBgView.constant = -16
        } else if indexPath.section == 1 {
            cell.setup(placeholder: Text.addDesc, text: eventDescription)
            cell.setup(isEnabled: true)
        } else if indexPath.section == 2 {
            if indexPath.row == rsvpArray.count {
                cell.setup(placeholder: "", text: "")
                cell.setup(placeholder: indexPath.row == 0 ? Text.addRSVP : Text.addAnotherRSVP)
                cell.setup(keyboardReturnKeyType: .done)
                cell.setup(isEnabled: false)
            } else {
                cell.setup(isHideCleareButton: false)
                cell.setup(isEnabled: false)
                cell.setup(placeholder: "", text: rsvpArray[indexPath.row])
            }
            cell.setup(iconImage: indexPath.row == 0 ? "addRSVP" : "")
        } else if indexPath.section == 3 {
            cell.setup(iconImage: "addLocation")
            cell.setup(placeholder: Text.addLocation, text: location)
            cell.setup(placeholder: Text.addLocation)
            cell.setup(isEnabled: false)
        } else if indexPath.section == 6 {
            if indexPath.row == interestList.count {
                cell.setup(placeholder: "", text: "")
                cell.setup(placeholder: indexPath.row == 0 ? Text.addInterest : Text.addAnotherInterest)
                cell.setup(keyboardReturnKeyType: .done)
                cell.setup(isEnabled: false)
            } else {
                cell.setup(isHideCleareButton: false)
                cell.setup(isEnabled: false)
                cell.setup(placeholder: "", text: interestList[indexPath.row])
            }
            cell.setup(iconImage: indexPath.row == 0 ? "interest-gray" : "")
        } else if indexPath.section == 7 {
            
            if indexPath.row == peopleList.count {
                cell.setup(placeholder: "", text: "")
                cell.setup(placeholder: indexPath.row == 0 ? Text.invitePeople : Text.inviteOtherPeople)
                cell.setup(isEnabled: false)
            } else {
                cell.setup(isHideCleareButton: false)
                cell.setup(placeholder: "", text: peopleList[indexPath.row])
            }
            cell.setup(iconImage: indexPath.row == 0 ? "friend-gray" : "")
        }
        
        cell.textDidChanged = {  [weak self] (text) in
            guard let unsafe = self else { return }
            if indexPath.section == 0 {
                unsafe.nameEvent = text
            } else if indexPath.section == 1 {
                unsafe.eventDescription = text
            }
            unsafe.validateAllFields()
        }
        
        cell.textDidEndEditing = { [weak self] (text) in
            guard let unsafe = self else { return }
            var txt = text
            if txt.last == "\n" {
                txt = String(txt.dropLast())
            }
            if text.isNotEmpty {
                if indexPath.section == 6 {
                    if !unsafe.interestList.contains(txt) {
                        unsafe.interestList.append(txt)
                        unsafe.tableView.reloadData()
                    }
                } else if indexPath.section == 7 {
                    if !unsafe.peopleList.contains(txt) {
                        unsafe.peopleList.append(txt)
                        unsafe.tableView.reloadData()
                    }
                }
            }
            unsafe.validateAllFields()
        }
        
        cell.clearButtonClickEvent = { [weak self] () in
            guard let unsafe = self else { return }
            
            if indexPath.section == 6 {
                if let index = unsafe.interestList.firstIndex(of: (unsafe.interestList[indexPath.row])) {
                    unsafe.interestList.remove(at: index)
                    unsafe.tableView.reloadData()
                }
            } else if indexPath.section == 7 {
                if let index = unsafe.peopleList.firstIndex(of: (unsafe.peopleList[indexPath.row])) {
                    unsafe.peopleList.remove(at: index)
                    unsafe.tableView.reloadData()
                }
            }
            unsafe.validateAllFields()
        }
        
        cell.updateTableView = {
            [weak self] (textView) in
            guard let unsafe = self else { return }
            let startHeight = textView.frame.size.height
            var calcHeight = textView.sizeThatFits(textView.frame.size).height
            if calcHeight == startHeight && textView.text.isEmpty {
                calcHeight += 1
            }
            if startHeight != calcHeight {
                // Disable animations
                UIView.setAnimationsEnabled(false)
                unsafe.tableView.beginUpdates()
                unsafe.tableView.endUpdates()
                // Enable animations
                UIView.setAnimationsEnabled(true)
            }
        }
    }
    
    func fillImageHeader(_ view: UserImagesHeaderView) {
        view.setup(image: eventImage)
        view.addPhotoButtonEvent = { [weak self] () in
            guard let unsafe = self else { return }
            unsafe.addImageFunction()
            //unsafe.openCameraOrLibrary(type: .photoLibrary)
        }
    }
}

// MARK: - Other functions
extension CreateEventViewController {
    private func showPermissionAlert(text: String) {
        Utils.alert(
            message: text,
            title: "Permission Requires",
            buttons: ["Cancel", "Settings"],
            handler: { (index) in
            if index == 1 {
                //Open settings
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
    }
    
    func validateAllFields() {
        if eventImage != nil && nameEvent.isNotEmpty && eventDescription.isNotEmpty && interestList.count > 0 && peopleList.count > 0 {
            navigationItem.rightBarButtonItem = saveBtnActive
        } else {
            navigationItem.rightBarButtonItem = saveBtnDisActive// saveBtnDisActive
        }
    }
}
