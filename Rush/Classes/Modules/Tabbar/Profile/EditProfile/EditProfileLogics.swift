//
//  EditProfileLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 04/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

// MARK: - Header delegate
extension EditProfileViewController: AddImageDelegate {
    
    func addPhotoOfProfile() {
        addImageFunction()
    }
}

// MARK: - Handlers
extension EditProfileViewController {
    
    func sectionCount() -> Int {
        return 5
    }
    
    func sectionHeight(_ section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : 47.0
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 3
        case 2: return 3
        case 3: return (profile?.majors?.count ?? 0) + 1
        case 4: return (profile?.minors?.count ?? 0) + 1
        default: return 0
        }
    }
    
    func fillProfileInfoCell(_ cell: EditProfileInfoCell, _ indexPath: IndexPath) {
        if indexPath.section == 1 {
            cell.set(isHideArrow: false)
            cell.set(isHideRightButton: true)
            if indexPath.row == 0 {
                cell.set(isHideArrow: true)
                cell.set(title: Text.fullName)
                cell.titleLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                cell.detailLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                let firstName = profile?.firstName ?? ""
                let lastName = profile?.lastName ?? ""
                let fullName = firstName + " " + lastName
                cell.set(detail: fullName)
            } else if indexPath.row == 1 {
                cell.set(title: Text.dateOfBirth)
                cell.set(detail: profile?.birthDate ?? "")
            } else if indexPath.row == 2 {
                cell.set(title: Text.relationship)
                cell.set(detail: profile?.relationship ?? "")
            }
        } else if indexPath.section == 2 {
            cell.set(isHideArrow: false)
            cell.set(isHideRightButton: true)
            if indexPath.row == 0 {
                cell.set(title: Text.university)
                cell.set(detail: profile?.university ?? "")
            } else if indexPath.row == 1 {
                cell.set(title: Text.level)
                cell.set(detail: profile?.educationLevel ?? "")
            } else if indexPath.row == 2 {
                cell.set(title: Text.year)
                cell.set(detail: profile?.educationYear ?? "")
            }
            
        }
    }
    
    func fillProfileMinorCell(_ cell: EditProfileMinorCell, _ indexPath: IndexPath) {
        cell.resetAllField()
        cell.setup(keyboardReturnKeyType: .done)
        
        if indexPath.section == 4 {
            if indexPath.row == Authorization.shared.profile?.minors?.count {
                cell.setup(placeholder: "", text: "")
                cell.setup(placeholder: indexPath.row == 0 ? Text.addMinor : Text.addAnotherMinor)
                cell.setup(isEnabled: false)
            } else {
                guard let minor = Authorization.shared.profile?.minors?[indexPath.row] else { return }
                cell.setup(isHideCleareButton: false)
                cell.setup(placeholder: "", text: minor)
            }
        }
        
        cell.textDidEndEditing = { [weak self] (text) in
            guard let unself = self else { return }
            var txt = text
            if txt.last == "\n" {
                txt = String(txt.dropLast())
            }
            if text.isNotEmpty {
                if indexPath.section == 4 {
                    if !(unself.profile?.minors?.contains(txt))! {
                        unself.profile?.minors?.append(txt)
                        unself.tableView.reloadData()
                    }
                }
            }
            
        }
        
        cell.clearButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            
            if indexPath.section == 4 {
                if let index = unself.profile?.minors?.firstIndex(of: (unself.profile?.minors?[indexPath.row] ?? "")) {
                    unself.profile?.minors?.remove(at: index)
                    unself.tableView.reloadData()
                }
            }
            //                   unself.validateAllFields()
        }
        
        cell.updateTableView = {
            [weak self] (textView) in
            guard let unself = self else { return }
            
            let startHeight = textView.frame.size.height
            var calcHeight = textView.sizeThatFits(textView.frame.size).height
            if calcHeight == startHeight && textView.text.isEmpty {
                calcHeight += 1
            }
            if startHeight != calcHeight {
                // Disable animations
                UIView.setAnimationsEnabled(false)
                unself.tableView.beginUpdates()
                unself.tableView.endUpdates()
                // Enable animations
                UIView.setAnimationsEnabled(true)
            }
        }
    }
    
    func fillProfileMajorCell(_ cell: EditProfileMinorCell, _ indexPath: IndexPath) {
        cell.resetAllField()
        cell.setup(keyboardReturnKeyType: .done)
        
        if indexPath.section == 3 {
            if indexPath.row == profile?.majors?.count {
                cell.setup(placeholder: "", text: "")
                cell.setup(placeholder: indexPath.row == 0 ? Text.addMajor : Text.addAnotherMajor)
                cell.setup(isEnabled: false)
            } else {
                guard let major = profile?.minors![indexPath.row] else { return }
                cell.setup(isHideCleareButton: false)
                cell.setup(placeholder: "", text: major)
            }
        }
        
        cell.textDidEndEditing = { [weak self] (text) in
            guard let unself = self else { return }
            var txt = text
            if txt.last == "\n" {
                txt = String(txt.dropLast())
            }
            if text.isNotEmpty {
                if indexPath.section == 3 {
                    if !(unself.profile?.majors?.contains(txt) ?? false) {
                        unself.profile?.minors?.append(txt)
                        unself.tableView.reloadData()
                    }
                }
            }
            
        }
        
        cell.clearButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            
            if indexPath.section == 3 {
                if let index = unself.profile?.majors?.firstIndex(of: (unself.profile?.majors?[indexPath.row] ?? "")) {
                    unself.profile?.majors?.remove(at: index)
                    unself.tableView.reloadData()
                }
            }
            //                   unself.validateAllFields()
        }
        
        cell.updateTableView = {
            [weak self] (textView) in
            guard let unself = self else { return }
            
            let startHeight = textView.frame.size.height
            var calcHeight = textView.sizeThatFits(textView.frame.size).height
            if calcHeight == startHeight && textView.text.isEmpty {
                calcHeight += 1
            }
            if startHeight != calcHeight {
                // Disable animations
                UIView.setAnimationsEnabled(false)
                unself.tableView.beginUpdates()
                unself.tableView.endUpdates()
                // Enable animations
                UIView.setAnimationsEnabled(true)
            }
        }
    }
    
    func selectedRow(_ indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 1://date of birth
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
                    self.present(datePikcerController, animated: false, completion: nil)
                }
            case 2://relationship
                    let customPickerStoryboard = UIStoryboard(name: StoryBoard.customPicker, bundle: nil)
                    if let customPickerController = customPickerStoryboard.instantiateViewController(withIdentifier: ViewControllerId.customPickerViewController) as? CustomPickerViewController {
                        customPickerController.pickerDelegate = self
                        customPickerController.presenter.type = .relation
                        customPickerController.presenter.selectedIndexIn = self.selectedRelation
                        customPickerController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                        self.present(customPickerController, animated: false, completion: nil)
                }
            default:
                break
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: Segues.chooseUniversitySegue, sender: nil)
            case 1:
                performSegue(withIdentifier: Segues.chooseLevelSegue, sender: nil)
            case 2:
                performSegue(withIdentifier: Segues.chooseYearSegue, sender: nil)
            default:
                break
            }
        } else if indexPath.section == 3 {
            performSegue(withIdentifier: Segues.addMajorViewSegue, sender: nil)
        } else if indexPath.section == 4 {
            performSegue(withIdentifier: Segues.addMinorViewSegue, sender: nil)
        }
    }
}

// MARK: - Date Picker Delegate
extension EditProfileViewController: DatePickerDelegate {
    func selectedDate(_ date: Date) {
        selectedDate = date
        dob = date.toString(format: "dd.MM.yyyy")
        profile?.birthDate = dob
        self.tableView.reloadData()
    }
}

// MARK: - Custom Picker delegate
extension EditProfileViewController: CustomPickerDelegate {
    func selectedValue(data: String, type: String) {
        if type == "Gender" {
            gender = data
            selectedGender = data == "Male" ? 0 : 1
            profile?.gender = gender
        } else {
            relation = data
            selectedRelation = data == "Taken" ? 1 : data == "Prefer not to say" ? 2 : 0
            profile?.relationship = data
        }
        
        tableView.reloadData()
    }
}
// MARK: - Other functions
extension EditProfileViewController {
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
    
}