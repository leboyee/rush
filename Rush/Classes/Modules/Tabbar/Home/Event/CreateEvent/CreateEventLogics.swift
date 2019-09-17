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
        if indexPath.section == 4 {
            return indexPath.row == 0 ? UITableView.automaticDimension : calendarHeight
        }
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        if section == 2 {
            return rsvpArray.count + 1
        } else if section == 4 {
            return isStartDate == true ? 2 : isStartTime == true ? 2 : 1
        } else if section == 4 {
            return isEndDate == true ? 2 : isEndTime == true ? 2 : 1
        } else if section == 6 {
            return interestList.count + 1
        } else if section == 7 {
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
    
    func fillAddCalendarCell(_ cell: AddEventCalendarCell, _ indexPath: IndexPath) {
        if indexPath.section == 4 {
            cell.calenderViewHeight.constant = calendarHeight
            cell.calendarView.delegate = self
        }
    }

    func fillDateAndTimeEvent(_ cell: DateAndTimeCell, _ indexPath: IndexPath) {
        
        if indexPath.section == 4 {
            cell.setup(dateButtonText: Date().eventDateFormat(date: startDate))
            cell.setup(timeButtonText: startTime.isEmpty == true ? "12 pm" : startTime)
            cell.separatorView.isHidden = true
            cell.dateButtonClickEvent = { [weak self] () in
                guard let unsafe = self else { return }
                unsafe.resetDateFileds()
                unsafe.isStartDate = true
                unsafe.tableView.reloadData()
               // Utils.alert(message: "In Development")
            }
            cell.timeButtonClickEvent = { () in
                Utils.alert(message: "In Development")
            }
        } else {
            
            cell.setup(dateButtonText: Date().eventDateFormat(date: endDate))
            cell.setup(timeButtonText: endTime.isEmpty == true ? "13 pm" : endTime)
            cell.separatorView.isHidden = false

            cell.dateButtonClickEvent = { [weak self] () in
                guard let unsafe = self else { return }
                unsafe.resetDateFileds()
                unsafe.isEndDate = true
                unsafe.tableView.reloadData()
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
                cell.setup(isUserInterfaceEnable: false)
                cell.setup(isEnabled: false)
            } else {
                cell.setup(isHideCleareButton: false)
                cell.setup(isEnabled: false)
                cell.setup(placeholder: "", text: rsvpArray[indexPath.row])
                cell.setup(isUserInterfaceEnable: false)
                cell.setup(isEnabled: false)
            }
            
            cell.clearButtonClickEvent = {
                [weak self] () in
                guard let unsafe = self else { return }
                
            }
            cell.setup(iconImage: indexPath.row == 0 ? "addRSVP" : "")
        } else if indexPath.section == 3 {
            cell.setup(iconImage: "addLocation")
            cell.setup(placeholder: Text.addLocation, text: address)
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
    
    func resetDateFileds() {
        isStartDate = false
        isEndDate = false
        isStartTime = false
        isEndTime = false
    }
}

extension CreateEventViewController: CalendarViewDelegate {
    
    func changeMonth(date: Date) {
        //DispatchQueue.main.async {
            self.startDate = date
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 4)) as? AddEventCalendarCell else { return }
        DispatchQueue.main.async {
            cell.calendarView.setSelectedDate(date: self.startDate)
        }
            self.tableView.reloadData()
        //}

    }
    
    func isEventExist(date: Date) -> Bool {
        return false
    }
    
    func setHeightOfView(height: CGFloat) {
        self.calendarHeight = height
        self.tableView.reloadData()
    }
    
    func selectedDate(date: Date) {
        print(date)
    }
}

// MARK: - SelectEventTypeController Delegate
extension CreateEventViewController: SelectEventTypeDelegate {
    func createEventClub(_ type: EventType, _ screenType: ScreenType) {
        
    }
    
    func addPhotoEvent(_ type: PhotoFrom) {
        if type == .cameraRoll {
            self.openCameraOrLibrary(type: .photoLibrary)
        } else {
            Utils.alert(message: "In Development")
        }
    }
}

// MARK: - Add Rsvp Delegate
extension CreateEventViewController: AddRsvpDelegate {
    func addRsvpData(_ rsvpArray: [String]) {
        self.rsvpArray.append(contentsOf: rsvpArray)
        self.tableView.reloadData()
    }
}

// MARK: - Add Location Delegate
extension CreateEventViewController: AddEventLocationDelegate {
    func addEventLocationData(_ address: String, latitude: Double, longitude: Double) {
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.tableView.reloadData()
    }
}
