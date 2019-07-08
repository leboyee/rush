//
//  ChooseYearViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

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
            break
        case 1:
            cell.setup(placeholder: "Gender", title: gender)
            cell.setup(iconImage: #imageLiteral(resourceName: "genderIcon"))
            break
        case 2:
            cell.setup(placeholder: "Relationship", title: relation)
            cell.setup(iconImage: #imageLiteral(resourceName: "relationShipIcon"))
            break
        case 3:
            cell.setup(placeholder: "Hometown", title: homeTown)
            cell.setup(iconImage: #imageLiteral(resourceName: "location-gray"))
            break
            
        default:
            break
        }
    }
    
    func selectedCell(indexPath: IndexPath) {
        DispatchQueue.main.async {
            switch indexPath.row {
            case 0:
                let customPickerStoryboard = UIStoryboard(name: StoryBoard.customPicker, bundle: nil)
                let datePikcerController : DatePickerViewController = customPickerStoryboard.instantiateViewController(withIdentifier: ViewControllerId.datePickerViewController) as! DatePickerViewController
                datePikcerController.pickerDelegate = self
                let calendar = Calendar.current
                var minDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
                minDateComponent.day = 01
                minDateComponent.month = 01
                minDateComponent.year = 1920
                let minDate = calendar.date(from: minDateComponent)
                datePikcerController.presenter.maxDate = Date().minus(years: 18)
                datePikcerController.presenter.minDate = minDate
                datePikcerController.presenter.currentDate = Date().minus(years: 19)
                datePikcerController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                
                self.present(datePikcerController, animated: false, completion: nil)
                
                break
            case 1:
                let customPickerStoryboard = UIStoryboard(name: StoryBoard.customPicker, bundle: nil)
                let customPickerController : CustomPickerViewController = customPickerStoryboard.instantiateViewController(withIdentifier: ViewControllerId.customPickerViewController) as! CustomPickerViewController
                customPickerController.pickerDelegate = self
                customPickerController.presenter.type = .gender
                customPickerController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                self.present(customPickerController, animated: false, completion: nil)
                break
            case 2:
                let customPickerStoryboard = UIStoryboard(name: StoryBoard.customPicker, bundle: nil)
                let customPickerController : CustomPickerViewController = customPickerStoryboard.instantiateViewController(withIdentifier: ViewControllerId.customPickerViewController) as! CustomPickerViewController
                customPickerController.pickerDelegate = self
                customPickerController.presenter.type = .relation
                customPickerController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                self.present(customPickerController, animated: false, completion: nil)
                
                break
            case 3:
                
                break
                
            default:
                break
            }
            
        }
        
    }
}

//MARK: - Date Picker Delegate
extension UserInfoViewController: DatePickerDelegate {
    func selectedDate(_ date: Date) {
        dob = Date().starnderDateFormate(date: date)
        nextButtonEnabled()
        self.tableView.reloadData()
    }
}

//MARK:- Custom Picker delegate
extension UserInfoViewController: CustomPickerDelegate {
    func selectedValue(data: String, type: String) {
        if type == "Gender" {
            gender = data
        }
        else {
            relation = data
        }
        nextButtonEnabled()
        tableView.reloadData()
    }
    
}


//MARK: - Manage Interator or API's Calling
extension UserInfoViewController {
    
}


