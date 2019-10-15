//
//  ChooseYearViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation

extension UserInfoViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
            return 64
    }
    
    func cellCount(_ section: Int) -> Int {
        return 4
    }
    
    func fillUserInfoCell(_ cell: UserInfoCell, _ indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.setup(placeholder: "Date of birth", title: dob)
            cell.setup(iconImage: #imageLiteral(resourceName: "calender-gray"))
        case 1:
            cell.setup(placeholder: "Gender", title: gender)
            cell.setup(iconImage: #imageLiteral(resourceName: "genderIcon"))
        case 2:
            cell.setup(placeholder: "Relationship", title: relation)
            cell.setup(iconImage: #imageLiteral(resourceName: "relationShipIcon"))
        case 3:
            cell.setup(placeholder: "Hometown", title: homeTown)
            cell.setup(iconImage: #imageLiteral(resourceName: "location-gray"))
        default:
            break
        }
    }
    
    func selectedCell(indexPath: IndexPath) {
        DispatchQueue.main.async {
            switch indexPath.row {
            case 0:
                let customPickerStoryboard = UIStoryboard(name: StoryBoard.customPicker, bundle: nil)
                if let datePikcerController = customPickerStoryboard.instantiateViewController(withIdentifier: ViewControllerId.datePickerViewController) as? DatePickerViewController {
                    datePikcerController.pickerDelegate = self
                    let calendar = Calendar.current
                    var minDateComponent = calendar.dateComponents([.day, .month, .year], from: Date())
                    minDateComponent.day = 01
                    minDateComponent.month = 01
                    minDateComponent.year = 1920
                    let minDate = calendar.date(from: minDateComponent)
                    datePikcerController.presenter.maxDate = Date().minus(years: 18)
                    datePikcerController.presenter.minDate = minDate
                    datePikcerController.presenter.currentDate = self.selectedDate
                    datePikcerController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                    self.nextButton.isHidden = true
                    self.present(datePikcerController, animated: false, completion: nil)
                }
            case 1:
                let customPickerStoryboard = UIStoryboard(name: StoryBoard.customPicker, bundle: nil)
                if let customPickerController = customPickerStoryboard.instantiateViewController(withIdentifier: ViewControllerId.customPickerViewController) as? CustomPickerViewController {
                    customPickerController.pickerDelegate = self
                    customPickerController.presenter.type = .gender
                    customPickerController.presenter.selectedIndexIn = self.selectedGender
                    customPickerController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                    self.nextButton.isHidden = true
                    self.present(customPickerController, animated: false, completion: nil)
                }
            case 2:
                let customPickerStoryboard = UIStoryboard(name: StoryBoard.customPicker, bundle: nil)
                if let customPickerController = customPickerStoryboard.instantiateViewController(withIdentifier: ViewControllerId.customPickerViewController) as? CustomPickerViewController {
                    customPickerController.pickerDelegate = self
                    customPickerController.presenter.type = .relation
                    customPickerController.presenter.selectedIndexIn = self.selectedRelation
                    customPickerController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                    self.nextButton.isHidden = true
                    self.present(customPickerController, animated: false, completion: nil)
                }
            case 3:
                self.performSegue(withIdentifier: Segues.addLocationSegue, sender: self)
            default:
                break
            }
            
        }
        
    }
}

// MARK: - Date Picker Delegate
extension UserInfoViewController: DatePickerDelegate {
    func selectedDate(_ date: Date) {
        nextButton.isHidden = false
        selectedDate = date
        dob = date.toString(format: "dd.MM.yyyy")
        nextButtonEnabled()
        self.tableView.reloadData()
    }
}

// MARK: - Custom Picker delegate
extension UserInfoViewController: CustomPickerDelegate {
    func selectedValue(data: String, type: String) {
        nextButton.isHidden = false
        if type == "Gender" {
            gender = data
            selectedGender = data == "Male" ? 0 : 1
        } else {
            relation = data
            selectedRelation = data == "Taken" ? 1 : data == "Prefer not to say" ? 2 : 0
        }
        nextButtonEnabled()
        tableView.reloadData()
    }
    
}

// MARK: - Manage Interator or API's Calling
extension UserInfoViewController {
    
}

// MARK: - Add Location Delegate
extension UserInfoViewController: AddEventLocationDelegate {
    func addEventLocationData(_ address: String, latitude: Double, longitude: Double) {
        self.homeTown = address
        self.latitude = latitude
        self.longitude = longitude
        nextButtonEnabled()
        self.tableView.reloadData()
    }
}

// MARK: - Manage Interator or API's Calling
extension UserInfoViewController {
    func updateProfileAPI() {
        
        let param = [Keys.userHomeTown: homeTown, Keys.userLatitude: "\(latitude)", Keys.userLongitude: "\(longitude)", Keys.userBirthDate: selectedDate.toString(format: "yyyy-MM-dd"), Keys.userGender: gender, Keys.userRelation: relation]  as [String: Any]
        Utils.showSpinner()
        ServiceManager.shared.updateProfile(params: param) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if data != nil {
                unsafe.profileUpdateSuccess()
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
