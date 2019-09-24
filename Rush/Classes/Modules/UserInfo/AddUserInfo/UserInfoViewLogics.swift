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
                    datePikcerController.presenter.currentDate = Date().minus(years: 19)
                    datePikcerController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                    self.present(datePikcerController, animated: false, completion: nil)
                }
            case 1:
                let customPickerStoryboard = UIStoryboard(name: StoryBoard.customPicker, bundle: nil)
                if let customPickerController = customPickerStoryboard.instantiateViewController(withIdentifier: ViewControllerId.customPickerViewController) as? CustomPickerViewController {
                    customPickerController.pickerDelegate = self
                    customPickerController.presenter.type = .gender
                    customPickerController.presenter.selectedIndexIn = self.selectedGender
                    customPickerController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                    self.present(customPickerController, animated: false, completion: nil)
                }
            case 2:
                let customPickerStoryboard = UIStoryboard(name: StoryBoard.customPicker, bundle: nil)
                if let customPickerController = customPickerStoryboard.instantiateViewController(withIdentifier: ViewControllerId.customPickerViewController) as? CustomPickerViewController {
                    customPickerController.pickerDelegate = self
                    customPickerController.presenter.type = .relation
                    customPickerController.presenter.selectedIndexIn = self.selectedRelation
                    customPickerController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                    self.present(customPickerController, animated: false, completion: nil)
                }
            case 3:
                let autocompleteController = GMSAutocompleteViewController()
                autocompleteController.delegate = self
                let filter = GMSAutocompleteFilter()
                filter.type = .address
                autocompleteController.autocompleteFilter = filter
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.white
                self.present(autocompleteController, animated: true, completion: nil)
            default:
                break
            }
            
        }
        
    }
}

// MARK: - Date Picker Delegate
extension UserInfoViewController: DatePickerDelegate {
    func selectedDate(_ date: Date) {
        dob = date.toString(format: "dd.MM.yyyy")
        nextButtonEnabled()
        self.tableView.reloadData()
    }
}

// MARK: - Custom Picker delegate
extension UserInfoViewController: CustomPickerDelegate {
    func selectedValue(data: String, type: String) {
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

// MARK: - Manage Interator or API's Calling
extension UserInfoViewController {
    func updateProfileAPI() {
        /*
        let param = [Keys.userInterests: selectedArray]  as [String : Any]
        Utils.showSpinner()
        ServiceManager.shared.updateProfile(params: param) {
            [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let self_ = self else { return }
            if data != nil {
                self_.profileUpdateSuccess()
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }*/
    }
}
