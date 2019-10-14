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
import UnsplashPhotoPicker
import PanModal

extension CreateEventViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        // Navigaiton height + cornerRadius height + changePhotoLabelOrigin
        return section == 0 ? 20 : CGFloat.leastNormalMagnitude
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 8
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 || indexPath.section == 5 {
            if indexPath.row == 0 {
                return 64
            } else {
                if self.isStartDate == true  || self.isEndDate == true {
                    return calendarHeight
                } else {
                    return 216
                }
            }
        }
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        if section == 0 {
            return isEditEvent == true ? 2 : 1
        } else if section == 2 {
            return rsvpArray.count + 1
        } else if section == 4 {
            return isStartDate == true ? 2 : isStartTime == true ? 2 : 1
        } else if section == 5 {
            return isEndDate == true ? 2 : isEndTime == true ? 2 : 1
        } else if section == 6 {
            return (interestList.count ?? 0) + 1
        } else if section == 7 {
            return peopleList.count + 1
        }
        return 1
    }
    
    func fillTextIconCell(_ cell: TextIconCell, _ indexPath: IndexPath) {
        
        cell.setup(placeholder: "", title: Text.createGroupChat)
        cell.setup(isShowSwitch: true)
        cell.setup(iconImage: "")
        
        cell.switchValueChanged = { [weak self] (isOn) in
            guard let unsafe = self else { return }
            unsafe.isCreateGroupChat = isOn
        }
    }
    
    func fillAddCalendarCell(_ cell: AddEventCalendarCell, _ indexPath: IndexPath) {
        if indexPath.section == 4 {
            cell.calendarView.delegate = self
            cell.calendarView.minimumSelectedDate = Date()
        } else if indexPath.section == 5 {
            cell.calendarView.delegate = self
            cell.calendarView.minimumSelectedDate = Date()
        }
    }
    
    func fillEventTimeCell(_ cell: EventTimeCell, _ indexPath: IndexPath) {
        cell.datePicker.date = indexPath.section == 4 ? startTimeDate : endTimeDate
        cell.timeSelected = {
            [weak self] (date) in
            guard let unsafe = self else { return }
            if indexPath.section == 4 {
                unsafe.startTimeDate = date
                cell.datePicker.date = date
                /*if unsafe.startDate.isSameDate(unsafe.endDate) && unsafe.startTimeDate > unsafe.endTimeDate {
                 Utils.alert(message: "Start time not allow greter then end event Time")
                 return
                 }*/
                unsafe.startTime = date.toString(format: "hh:mm a")
                unsafe.tableView.reloadData()
                
            } else {
                unsafe.endTimeDate = date
                /*if unsafe.startDate.isSameDate(unsafe.endDate) &&
                 unsafe.startTimeDate > unsafe.endTimeDate {
                 Utils.alert(message: "End time not allow smaller then start event Time")
                 return
                 }*/
                unsafe.endTimeDate = date
                unsafe.endTime = date.toString(format: "hh:mm a")
                unsafe.tableView.reloadData()
            }
        }
    }
    
    func fillDateAndTimeEvent(_ cell: DateAndTimeCell, _ indexPath: IndexPath) {
        
        if indexPath.section == 4 {
            cell.setup(dateButtonText: self.startDate.toString(format: "EEE, dd MMM"))
            cell.setup(timeButtonText: startTime.isEmpty == true ? "01:00 PM" : startTime)
            cell.separatorView.isHidden = true
            cell.dateButtonClickEvent = { [weak self] () in
                guard let unsafe = self else { return }
                if unsafe.isStartDate == false {
                    unsafe.resetDateFileds()
                    unsafe.isStartDate = true
                    unsafe.tableView.reloadData()
                } else {
                    unsafe.resetDateFileds()
                    unsafe.isStartDate = false
                    unsafe.tableView.reloadData()
                }
            }
            cell.timeButtonClickEvent = { [weak self] () in
                guard let unsafe = self else { return }
                if unsafe.isStartTime == false {
                    unsafe.resetDateFileds()
                    unsafe.isStartTime = true
                    unsafe.tableView.reloadData()
                } else {
                    unsafe.resetDateFileds()
                    unsafe.isStartTime = false
                    unsafe.tableView.reloadData()
                }
            }
        } else {
            cell.setup(dateButtonText: self.endDate.toString(format: "EEE, dd MMM"))
            cell.setup(timeButtonText: endTime.isEmpty == true ? "02:00 PM" : endTime)
            cell.separatorView.isHidden = false
            cell.dateButtonClickEvent = { [weak self] () in
                guard let unsafe = self else { return }
                if unsafe.isEndDate == false {
                    unsafe.resetDateFileds()
                    unsafe.isEndDate = true
                    unsafe.tableView.reloadData()
                } else {
                    unsafe.resetDateFileds()
                    unsafe.isEndDate = false
                    unsafe.tableView.reloadData()
                }
            }
            
            cell.timeButtonClickEvent = { [weak self] () in
                guard let unsafe = self else { return }
                if unsafe.isEndTime == false {
                    unsafe.resetDateFileds()
                    unsafe.isEndTime = true
                    unsafe.tableView.reloadData()
                } else {
                    unsafe.resetDateFileds()
                    unsafe.isEndTime = false
                    unsafe.tableView.reloadData()
                }
            }
        }
    }
    
    func fillTextViewFirstSection(_ cell: TextViewCell, _ indexPath: IndexPath) {
        cell.resetAllField()
        cell.setup(keyboardReturnKeyType: .done)
        if isEditEvent == false {
            cell.setup(iconImage: "nameEvent")
            cell.setup(placeholder: Text.nameEvent, text: nameEvent)
            cell.setup(isEnabled: true)
            cell.topConstraintOfBgView.constant = -16
        } else {
            if indexPath.row == 0 {
                cell.setEventType(type: event?.eventType ?? .publik)
                cell.setup(isEnabled: true)
                cell.setupButtonImage(image: UIImage(named: "downArrow") ?? UIImage())
                cell.setupButtonDisable(isDisable: true)
                cell.setup(isHideClearButton: false)
                cell.setup(isEnabled: false)
                cell.topConstraintOfBgView.constant = -16
                cell.topTextViewConstraint.constant = 20
            } else {
                cell.setup(iconImage: "nameEvent")
                cell.setup(placeholder: Text.nameEvent, text: self.event?.title ?? "")
                cell.setup(isEnabled: false)
                cell.setup(textViewColor: UIColor.lightGrayColor)
                //cell.topConstraintOfBgView.constant = -16
            }
        }
        cell.textDidChanged = {  [weak self] (text) in
            guard let unsafe = self else { return }
            
            if indexPath.section == 0 && unsafe.isEditEvent == false {
                unsafe.nameEvent = text
            } else {
                unsafe.nameEvent = text
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
                
            }
            unsafe.validateAllFields()
        }
        
        cell.clearButtonClickEvent = { //[weak self] () in
            //guard let unsafe = self else { return }
        }
        
    }
    
    func fillTextViewCell(_ cell: TextViewCell, _ indexPath: IndexPath) {
        cell.resetAllField()
        cell.setup(keyboardReturnKeyType: .done)
        if indexPath.section == 1 {
            cell.setup(placeholder: Text.addDesc, text: eventDescription)
            cell.setup(isEnabled: isEditEvent == true ? false : true)
            cell.setup(textViewColor: isEditEvent == true ? UIColor.lightGrayColor : UIColor.bgBlack)
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
            cell.setup(iconImage: indexPath.row == 0 ? "addRSVP" : "")
        } else if indexPath.section == 3 {
            cell.setup(iconImage: "addLocation")
            cell.setup(placeholder: Text.addLocation, text: address)
            cell.setup(placeholder: Text.addLocation)
            cell.setup(isHideClearButton: address.isEmpty)
            cell.setup(isEnabled: false)
        } else if indexPath.section == 6 {
            if indexPath.row == (interestList.count) {
                cell.setup(placeholder: "", text: "")
                cell.setup(placeholder: indexPath.row == 0 ? Text.addInterest : Text.addAnotherInterest)
                cell.setup(keyboardReturnKeyType: .done)
                cell.setup(isEnabled: false)
            } else {
                let interest = self.interestList[indexPath.row]
                cell.setup(isHideCleareButton: false)
                cell.setup(isEnabled: false)
                // S*
                cell.setup(placeholder: "", text: interest.interestName)
            }
            cell.setup(iconImage: indexPath.row == 0 ? "interest-gray" : "")
        } else if indexPath.section == 7 {
            if indexPath.row == peopleList.count {
                cell.setup(placeholder: "", text: "")
                cell.setup(placeholder: indexPath.row == 0 ? Text.invitePeople : Text.inviteOtherPeople)
                cell.setup(isEnabled: false)
            } else {
                let invite = peopleList[indexPath.row]
                cell.setup(isHideCleareButton: false)
                cell.setup(placeholder: "", text: (invite.isFriend == true ? invite.profile?.name : invite.contact?.displayName) ?? "")
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
                
            }
            unsafe.validateAllFields()
        }
        
        cell.clearButtonClickEvent = { [weak self] () in
            guard let unsafe = self else { return }
            
            if indexPath.section == 2 {
                if let index = unsafe.rsvpArray.firstIndex(of: (unsafe.rsvpArray[indexPath.row])) {
                    unsafe.rsvpArray.remove(at: index)
                    unsafe.tableView.reloadData()
                }
            } else if indexPath.section == 3 {
                unsafe.address = ""
                unsafe.tableView.reloadData()
            } else if indexPath.section == 6 {
                // S*
                let interest = unsafe.interestList[indexPath.row] 
                if let index = unsafe.interestList.firstIndex(where: { $0.interestName == interest.interestName }) {
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
        var array = rsvpArray
        if array.last?.isEmpty == true {
            array.remove(at: array.count - 1)
        }
        if (eventImage != nil || self.clubHeader.userImageView.image != nil) && nameEvent.isNotEmpty && (interestList.count ) > 0 {
            
            saveButton.isEnabled = true
            saveButton.setImage(#imageLiteral(resourceName: "save-active"), for: .normal)
            
        } else {
            saveButton.isEnabled = false
            saveButton.setImage(#imageLiteral(resourceName: "save-dark"), for: .normal)
        }
    }
    
    func resetDateFileds() {
        isStartDate = false
        isEndDate = false
        isStartTime = false
        isEndTime = false
    }
    
    func downloadPhoto(_ photo: UnsplashPhoto) {
        guard let url = photo.urls[.regular] else { return }
        
        if let cachedResponse = CreateEventViewController.cache.cachedResponse(for: URLRequest(url: url)),
            let image = UIImage(data: cachedResponse.data) {
            eventImage = image
            clubHeader.setup(image: eventImage)
            self.tableView.reloadData()
            self.validateAllFields()
            return
        }
        
        imageDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let strongSelf = self else { return }
            
            strongSelf.imageDataTask = nil
            
            guard let data = data, let image = UIImage(data: data), error == nil else { return }
            let imageView = UIImageView()
            DispatchQueue.main.async {
                UIView.transition(with: imageView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    strongSelf.eventImage = image
                    strongSelf.clubHeader.setup(image: image)
                    strongSelf.tableView.reloadData()
                    strongSelf.validateAllFields()
                }, completion: nil)
            }
        }
        
        imageDataTask?.resume()
    }
    
    func fillImageHeader() {
        clubHeader.setup(image: eventImage)
        clubHeader.delegate = self
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
        cell.calenderViewHeight.constant = calendarHeight
        cell.layoutIfNeeded()
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
        
        let newDate = Date().convertDateToDate(date: date)
        if isStartDate == true {
            self.startDate = newDate
            if newDate > endDate {
                endDate = newDate
            }
        } else if isEndDate == true {
            self.endDate = newDate
            if startDate > newDate {
                startDate = newDate
            }
        }
        resetDateFileds()
        self.tableView.reloadData()
    }
}

// MARK: - SelectEventTypeController Delegate
extension CreateEventViewController: SelectEventTypeDelegate {
    func createEventClub(_ type: EventType, _ screenType: ScreenType) {
        self.eventType = type
        validateAllFields()
    }
    
    func addPhotoEvent(_ type: PhotoFrom) {
        if type == .cameraRoll {
            self.openCameraOrLibrary(type: .photoLibrary, isFromUnsplash: false)
        } else {
            self.openCameraOrLibrary(type: .photoLibrary, isFromUnsplash: true)
        }
    }
}

// MARK: - Club header delegate
extension CreateEventViewController: ClubHeaderDelegate {
    func infoOfClub() {
        
    }
    
    func addPhotoOfClub() {
        addImageFunction()
    }
}

// MARK: - UnsplashPhotoPickerDelegate
extension CreateEventViewController: UnsplashPhotoPickerDelegate {
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
        print("Unsplash photo picker did select \(photos.count) photo(s)")
        if let photo = photos.first {
            self.downloadPhoto(photo)
        }
        
        self.tableView.reloadData()
    }
    
    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        print("Unsplash photo picker did cancel")
    }
}

// MARK: - Add Rsvp Delegate
extension CreateEventViewController: AddRsvpDelegate {
    func addRsvpData(_ rsvpArray: [String]) {
        self.rsvpArray.append(contentsOf: rsvpArray)
        self.tableView.reloadData()
        self.validateAllFields()
    }
}

// MARK: - Add Location Delegate
extension CreateEventViewController: AddEventLocationDelegate {
    func addEventLocationData(_ address: String, latitude: Double, longitude: Double) {
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.tableView.reloadData()
        self.validateAllFields()
    }
}

// MARK: - EventPanModel
extension CreateEventViewController: EventCategoryFilterDelegate {
    func selectedIndex(_ type: String) {
        if type == "0" {
            self.event?.eventType = .publik
            self.eventType = .publik
        } else if type == "1" {
            self.event?.eventType = .closed
            self.eventType = .closed
        } else if type == "2" {
            self.event?.eventType = .inviteOnly
            self.eventType = .inviteOnly
        }
        self.tableView.reloadData()
        self.validateAllFields()
    }
}

// MARK: - Add Invities Delegate
extension CreateEventViewController: EventInviteDelegate {
    func selectedInvities(_ invite: [Invite]) {
        self.peopleList.append(contentsOf: invite)
        self.tableView.reloadData()
        self.validateAllFields()

    }
}

// MARK: - Add Interest Delegate
extension CreateEventViewController: EventInterestDelegate {
    func  selectedInterest(_ interest: [Interest]) {
        // S*
        self.interestList = interest
        validateAllFields()
        self.tableView.reloadData()
        
    }
}
// MARK: - Services
extension CreateEventViewController {
    
    func createEventAPI() {
        let img = eventImage?.jpegData(compressionQuality: 0.8) ?? Data()
        // S*
        //let interests = interestList.joined(separator: ",")
        let interests = ""
        let friendArray = self.peopleList.filter { ($0.isFriend == true) }
        let userIdArray = friendArray.compactMap { ($0.profile?.userId) }
        let contactList = self.peopleList.filter { ($0.isFriend == false) }
        let contactNoArray = contactList.compactMap { ($0.contact?.phone) }
        
        var array = rsvpArray
        if array.last?.isEmpty == true {
            array.remove(at: array.count - 1)
        }
        let startDateString = self.startDate.toString(format: "yyyy-MM-dd") + " \(startTime)"
        let startUtcDate = Date().localToUTC(date: startDateString, toForamte: "yyyy-MM-dd hh:mm a", getFormate: "yyyy-MM-dd HH:mm")
        let endDateString = self.endDate.toString(format: "yyyy-MM-dd") + " \(endTime)"
        let endUtcDate = Date().localToUTC(date: endDateString, toForamte: "yyyy-MM-dd hh:mm a", getFormate: "yyyy-MM-dd HH:mm")
        print(startUtcDate)
        print(endUtcDate)
        var rsvpJson: String = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: array)
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                rsvpJson = JSONString
            }
        } catch {
            print(error.localizedDescription)
        }
        
        let eventTypeString = event?.eventType == .closed ? "closed" : event?.eventType == .publik ? "public" : "invite_only"

        let param = [Keys.createEventType: eventTypeString,
                     Keys.eventName: self.nameEvent,
                     Keys.eventDesc: self.eventDescription,
                     Keys.eventRsvpList: rsvpJson,
                     Keys.eventAddress: address,
                     Keys.eventLatitude: "\(latitude)",
            Keys.eventLongitude: "\(longitude)",
            Keys.eventStartDate: startUtcDate, //"2019-10-12 07:30:00", //startUtcDate,
            Keys.eventEndDate: endUtcDate, //"2019-10-12 08:30:00", //endUtcDate,
            Keys.eventInterests: interests,
            Keys.eventIsChatGroup: isCreateGroupChat ? 1 : 0,
            Keys.eventInvitedUserIds: userIdArray.joined(separator: ","),
            Keys.eventPhoto: img,
            Keys.eventContact: contactNoArray.joined(separator: ",")] as [String: Any]
        
        Utils.showSpinner()
        ServiceManager.shared.createEvent(params: param) { [weak self] (status, errMessage) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if status {
                unsafe.navigationController?.popViewController(animated: true)
            } else {
                Utils.alert(message: errMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func updateEventApi(eventId: String) {
        if eventImage == nil {
            eventImage = clubHeader.userImageView.image
        }

        let eventTypeString = event?.eventType == .closed ? "closed" : event?.eventType == .publik ? "public" : "invite_only"
            
        let img = eventImage?.jpegData(compressionQuality: 0.8) ?? Data()
        // S*
        let interestsNameArry = interestList.map({ $0.interestName })
        //interestList.joined(separator: ",")
        let interests = interestsNameArry.joined(separator: ",")
        let friendArray = self.peopleList.filter { ($0.isFriend == true) }
        let userIdArray = friendArray.compactMap { ($0.profile?.userId) }
        let contactList = self.peopleList.filter { ($0.isFriend == false) }
        let contactNoArray = contactList.compactMap { ($0.contact?.phone) }
        
        var array = rsvpArray
        if array.last?.isEmpty == true {
            array.remove(at: array.count - 1)
        }
        let startDateString = self.startDate.toString(format: "yyyy-MM-dd") + " \(startTime)"
        let startUtcDate = Date().localToUTC(date: startDateString, toForamte: "yyyy-MM-dd hh:mm a", getFormate: "yyyy-MM-dd HH:mm")
        let endDateString = self.endDate.toString(format: "yyyy-MM-dd") + " \(endTime)"
        let endUtcDate = Date().localToUTC(date: endDateString, toForamte: "yyyy-MM-dd hh:mm a", getFormate: "yyyy-MM-dd HH:mm")
        print(startUtcDate)
        print(endUtcDate)
        var rsvpJson: String = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: array)
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                rsvpJson = JSONString
            }
        } catch {
            print(error.localizedDescription)
        }
        
        let param = [Keys.eventId: eventId,
                     Keys.createEventType: eventTypeString,
                     Keys.eventName: self.nameEvent,
                     Keys.eventDesc: self.eventDescription,
                     Keys.eventRsvpList: rsvpJson,
                     Keys.eventAddress: address,
                     Keys.eventLatitude: "\(latitude)",
            Keys.eventLongitude: "\(longitude)",
            Keys.eventStartDate: startUtcDate, //"2019-10-12 07:30:00", //startUtcDate,
            Keys.eventEndDate: endUtcDate, //"2019-10-12 08:30:00", //endUtcDate,
            Keys.eventInterests: interests,
            Keys.eventIsChatGroup: isCreateGroupChat ? 1 : 0,
            Keys.eventInvitedUserIds: userIdArray.joined(separator: ","),
            Keys.eventPhoto: img,
            Keys.eventContact: contactNoArray.joined(separator: ",")] as [String: Any]
        
        Utils.showSpinner()
        ServiceManager.shared.updateEvent(eventId: eventId, params: param) { [weak self] (status, errMessage) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if status {
                unsafe.updatedEventSuccesssully()
            } else {
                Utils.alert(message: errMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func deleteEventAPI(id: String) {
       Utils.showSpinner()
       ServiceManager.shared.deleteEvent(eventId: id) { [weak self] (status, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if status {
                unsafe.navigationController?.popToRootViewController(animated: true)
            } else if let message = errorMsg {
                Utils.alert(message: message)
            }
        }
    }
}
