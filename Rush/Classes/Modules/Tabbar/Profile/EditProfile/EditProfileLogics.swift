//
//  EditProfileLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 04/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

// MARK: - Handlers
extension EditProfileViewController {
    
    func sectionCount() -> Int {
        return 5
    }
    
    func sectionHeight(_ section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : 47.0
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 || indexPath.section == 2 {
            if indexPath.section == 2 && indexPath.row == 0 {
                return UITableView.automaticDimension
            } else {
                return 64
            }
        }
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 3
        case 2: return 3
        case 3: return (majorArray.count) + 1
        case 4: return (minorArray.count) + 1
        default: return 0
        }
    }
    
    func fillProfileInfoCell(_ cell: EditProfileInfoCell, _ indexPath: IndexPath) {
        if indexPath.section == 1 {
            cell.set(isHideArrow: false)
            cell.set(isHideRightButton: true)
            cell.set(arrowImage: #imageLiteral(resourceName: "downArrow"))
            if indexPath.row == 0 {
                cell.set(isHideArrow: true)
                cell.set(title: Text.fullName)
                cell.set(titleTextColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
                cell.set(detailsTextColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
                cell.set(detail: profile?.name ?? "")
            } else if indexPath.row == 1 {
                cell.set(title: Text.dateOfBirth)
                let birthDate = Date.parse(dateString: profile?.birthDate ?? "", format: "yyyy-MM-dd")
                let birthDateString = birthDate?.toString(format: "MM.dd.yyyy")
                cell.set(detail: birthDateString ?? "")
                cell.set(isDetails: profile?.birthDate?.isNotEmpty ?? false)
            } else if indexPath.row == 2 {
                cell.set(title: Text.relationship)
                cell.set(detail: profile?.relationship ?? "")
                cell.set(isDetails: profile?.relationship?.isNotEmpty ?? false)
            }
        } else if indexPath.section == 2 {
            cell.set(isHideArrow: false)
            cell.set(arrowImage: #imageLiteral(resourceName: "ic_leftArrow"))
            cell.set(isHideRightButton: true)
            if indexPath.row == 0 {
                let universityArray = profile?.university
                let university = universityArray?.first
                cell.set(title: Text.university)
                cell.set(detail: university?.universityName ?? "")
                cell.set(isDetails: university?.universityName.isNotEmpty ?? false)
            } else if indexPath.row == 1 {
                cell.set(title: Text.level)
                cell.set(detail: profile?.educationLevel ?? "")
                cell.set(isDetails: profile?.educationLevel?.isNotEmpty ?? false)
            } else if indexPath.row == 2 {
                cell.set(title: Text.year)
                cell.set(detail: profile?.educationYear ?? "")
                cell.set(isDetails: profile?.educationYear?.isNotEmpty ?? false)
            }
            
        }
    }
    
    func fillProfileImageCell(_ cell: EditProfileImageCell, _ indexPath: IndexPath) {
        guard let urlString = profile?.photo?.main else { return }
        cell.setup(url: URL(string: urlString) ?? URL(fileURLWithPath: ""))
    }

    func fillProfileMajorCell(_ cell: EditProfileMinorCell, _ indexPath: IndexPath) {
        cell.resetAllField()
        cell.setup(keyboardReturnKeyType: .done)
        if indexPath.section == 3 {
            if indexPath.row == majorArray.count {
                cell.setup(placeholder: indexPath.row == 0 ? Text.addMajor : Text.addAnotherMajor, text: "")
                cell.setup(isEnabled: false)
            } else {
                let majorObject = majorArray[indexPath.row]
                cell.setup(isHideCleareButton: false)
                cell.setup(isEnabled: false)
                cell.setup(placeholder: "", text: majorObject)
            }
        } else if indexPath.section == 4 {
            if indexPath.row == minorArray.count {
                cell.setup(placeholder: "", text: "")
                cell.setup(placeholder: indexPath.row == 0 ? Text.addMinor : Text.addAnotherMinor)
                cell.setup(isEnabled: false)
            } else {
                let minorObject = minorArray[indexPath.row]
                cell.setup(isHideCleareButton: false)
                cell.setup(placeholder: "", text: minorObject)
                cell.setup(isEnabled: false)
            }
        }
        
        cell.textDidEndEditing = { (text) in
            var txt = text
            if txt.last == "\n" {
                txt = String(txt.dropLast())
            }
        }
        
        cell.clearButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            
            if indexPath.section == 3 {
                if let index = unself.majorArray.firstIndex(of: (unself.majorArray[indexPath.row])) {
                    unself.majorArray.remove(at: index)
                    let param = [Keys.uEduMajors: unself.majorArray]  as [String: Any]
                    unself.updateProfileAPI(param: param)
                }
            } else   if indexPath.section == 4 {
                if let index = unself.minorArray.firstIndex(of: (unself.minorArray[indexPath.row])) {
                    unself.minorArray.remove(at: index)
                    let param = [Keys.uEduMinors: unself.minorArray]  as [String: Any]
                    unself.updateProfileAPI(param: param)
                }
            }
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
        if indexPath.section == 0 {
            photoLibraryPermissionCheck()
        } else if indexPath.section == 1 {
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
                if profile?.educationLevel == "Alumni" || profile?.educationLevel == "Professor" {
                } else {
                    performSegue(withIdentifier: Segues.chooseYearSegue, sender: nil)
                }
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
        let param = [Keys.userBirthDate: selectedDate.toString(format: "yyyy.MM.dd")]  as [String: Any]
        updateProfileAPI(param: param)
        //self.tableView.reloadData()
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
            let param = [Keys.userRelation: relation]  as [String: Any]
            updateProfileAPI(param: param)

        }
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

// MARK: - Manage Interator or API's Calling
extension EditProfileViewController {
    
    func updateProfileImageAPI(param: [String: Any]) {
        Utils.showSpinner()
        ServiceManager.shared.uploadUserProfileImage(params: param) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if data != nil {
                (unsafe.tabBarController as? CustomTabbarViewController)?.isImageUpdate = true
                unsafe.profile = Authorization.shared.profile
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func updateProfileAPI(param: [String: Any]) {
        Utils.showSpinner()
        ServiceManager.shared.updateProfile(params: param) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if data != nil {
                unsafe.profile = Authorization.shared.profile
                unsafe.majorMinorData()
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
}
