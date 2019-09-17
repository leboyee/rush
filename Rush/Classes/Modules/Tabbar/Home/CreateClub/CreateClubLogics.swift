//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos
import IQKeyboardManagerSwift

extension CreateClubViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return section == 0 ? 20 : CGFloat.leastNormalMagnitude
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
        
        cell.switchValueChanged = { [weak self] (isOn) in
            guard let unsafe = self else { return }
            unsafe.isCreateGroupChat = isOn
        }
    }
    
    func fillTextViewCell(_ cell: TextViewCell, _ indexPath: IndexPath) {
        
        cell.resetAllField()
        cell.setup(keyboardReturnKeyType: .done)
        if indexPath.section == 0 {
            cell.setup(iconImage: "club-gray-1")
            cell.setup(placeholder: Text.nameClub, text: nameClub)
            cell.setup(isUserInterfaceEnable: true)
            cell.topConstraintOfBgView.constant = -16
        } else if indexPath.section == 1 {
            cell.setup(placeholder: Text.addDesc, text: clubDescription)
        } else if indexPath.section == 2 {
            if indexPath.row == interestList.count {
                cell.setup(placeholder: "", text: "")
                cell.setup(placeholder: indexPath.row == 0 ? Text.addInterest : Text.addAnotherInterest)
                cell.setup(keyboardReturnKeyType: .done)
                cell.setup(isUserInterfaceEnable: false)
            } else {
                cell.setup(isHideCleareButton: false)
                cell.setup(placeholder: "", text: interestList[indexPath.row])
            }
            cell.setup(iconImage: indexPath.row == 0 ? "interest-gray" : "")
        } else if indexPath.section == 3 {
            if indexPath.row == peopleList.count {
                cell.setup(placeholder: "", text: "")
                cell.setup(placeholder: indexPath.row == 0 ? Text.invitePeople : Text.inviteOtherPeople)
                cell.setup(isUserInterfaceEnable: false)
            } else {
                cell.setup(isHideCleareButton: false)
                cell.setup(placeholder: "", text: peopleList[indexPath.row].displayName)
            }
            cell.setup(iconImage: indexPath.row == 0 ? "friend-gray" : "")
            cell.textView.isUserInteractionEnabled = false
        }
        
        cell.textDidChanged = {  [weak self] (text) in
            guard let unself = self else { return }
            if indexPath.section == 0 {
                unself.nameClub = text
            } else if indexPath.section == 1 {
                unself.clubDescription = text
            }
            unself.validateAllFields()
        }
        
        cell.textDidEndEditing = { [weak self] (text) in
            guard let unself = self else { return }
            var txt = text
            if txt.last == "\n" {
                txt = String(txt.dropLast())
            }
            if text.isNotEmpty {
                if indexPath.section == 2 {
                    if !unself.interestList.contains(txt) {
                        unself.interestList.append(txt)
                        unself.tableView.reloadData()
                    }
                } else if indexPath.section == 3 {
                    
                    //                    if !self_.peopleList.contains(txt) {
                    //                        self_.peopleList.append(txt)
                    //                        self_.tableView.reloadData()
                    //                    }
                }
            }
            unself.validateAllFields()
        }
        
        cell.clearButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            
            if indexPath.section == 2 {
                if let index = unself.interestList.firstIndex(of: (unself.interestList[indexPath.row])) {
                    unself.interestList.remove(at: index)
                    unself.tableView.reloadData()
                }
            } else if indexPath.section == 3 {
                if let index = unself.peopleList.firstIndex(of: (unself.peopleList[indexPath.row])) {
                    unself.peopleList.remove(at: index)
                    unself.tableView.reloadData()
                }
            }
            unself.validateAllFields()
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
    
    func fillImageHeader() {
        clubHeader.setup(image: clubImage)
        clubHeader.delegate = self
    }
}

// MARK: - Other functions
extension CreateClubViewController {
    // MARK: - Capture Image
    func openCameraOrLibrary(type: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            
            if type == .photoLibrary {
                let status = PHPhotoLibrary.authorizationStatus()
                
                if status == .notDetermined {
                    Utils.authorizePhoto(completion: { (statusF) in
                        if statusF == .alreadyDenied {
                            self.showPermissionAlert(text: Message.phPhotoLibraryAuthorizedMesssage)
                            return
                        }
                    })
                } else {
                    guard status == .authorized else {
                        self.showPermissionAlert(text: Message.phPhotoLibraryAuthorizedMesssage)
                        return
                    }
                }
            } else {
                let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                guard status == .authorized else {
                    self.showPermissionAlert(text: Message.cameraAuthorizedMesssage)
                    return
                }
            }
            
            if UIImagePickerController.isSourceTypeAvailable(type) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = type
                imagePicker.allowsEditing = false
                imagePicker.navigationBar.isTranslucent = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    private func showPermissionAlert(text: String) {
        Utils.alert(message: text, title: "Permission Requires", buttons: ["Cancel", "Settings"], handler: { (index) in
            if index == 1 {
                //Open settings
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
    }
    
    func validateAllFields() {
        if clubImage != nil && nameClub.isNotEmpty && clubDescription.isNotEmpty && interestList.count > 0 && peopleList.count > 0 {
            saveButton.isEnabled = true
            saveButton.setImage(#imageLiteral(resourceName: "save-active"), for: .normal)
        } else {
            // saveBtnDisActive
            saveButton.isEnabled = false
            saveButton.setImage(#imageLiteral(resourceName: "save-dark"), for: .normal)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate methods
extension CreateClubViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        autoreleasepool {
            var captureImage = info[UIImagePickerController.InfoKey.originalImage]
                as? UIImage
            if #available(iOS 11, *), captureImage == nil {
                if PHPhotoLibrary.authorizationStatus() == .authorized {
                    let manager = PHImageManager.default()
                    let requestOptions = PHImageRequestOptions()
                    requestOptions.isSynchronous = true
                    if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: requestOptions, resultHandler: { (image, _) in
                            if image != nil {
                                captureImage = image
                            }
                        })
                    }
                } else {
                    //Show Alert for error
                    showPermissionAlert(text: Message.phPhotoLibraryAuthorizedMesssage)
                }
            }
            IQKeyboardManager.shared.enableAutoToolbar = false
            DispatchQueue.main.async {
                self.clubImage = captureImage
                self.validateAllFields()
                self.fillImageHeader()
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        IQKeyboardManager.shared.enableAutoToolbar = false
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - Services
extension CreateClubViewController {
    
    func createClubAPI() {
        
        let img = clubImage?.jpegData(compressionQuality: 0.8) ?? Data()
        let interests = interestList.joined(separator: ",")
        let userIds = "5d5d213239277643e20f9bf1,5d3066d3392776515c7df011"
        
        let param = [Keys.clubName: nameClub,
                     Keys.clubDesc: clubDescription,
                     Keys.clubInterests: interests,
                     Keys.clubInvitedUserIds: userIds,
                     Keys.clubIsChatGroup: isCreateGroupChat ? 1 : 0,
                     Keys.clubPhoto: img] as [String: Any]
        
        Utils.showSpinner()
        ServiceManager.shared.createClub(params: param) { [weak self] (data, errMessage) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let club = data?[Keys.club] as? [String: Any] {
                do {
                    let dataClub = try JSONSerialization.data(withJSONObject: club, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    let value = try decoder.decode(Club.self, from: dataClub)
                    unsafe.performSegue(withIdentifier: Segues.clubDetailSegue, sender: value)
                } catch {
                    
                }
            } else {
                Utils.alert(message: errMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
