//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

extension CreateClubViewController {
    
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
        
        cell.resetAllField()
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.setup(topLabelConstraint: 2)
            cell.setup(iconImage: "club-gray-1")
            cell.setup(placeholder: Text.nameClub, title: nameClub)
            cell.setup(isUserInterfaceEnable: true)
        } else if indexPath.section == 1 {
            cell.setup(placeholder: Text.addDesc, title: clubDescription)
        } else if indexPath.section == 2 {
            if indexPath.row == interestList.count {
                cell.setup(placeholder: "", title: "")
                cell.setup(placeholder: indexPath.row == 0 ? Text.addInterest : Text.addAnotherInterest)
                cell.setup(keyboardReturnKeyType: .done)
                cell.setup(isUserInterfaceEnable: false)
            } else {
                cell.setup(isHideCleareButton: false)
                cell.setup(placeholder: "", title: interestList[indexPath.row])
            }
            cell.setup(iconImage: indexPath.row == 0 ? "interest-gray" : "")
        } else if indexPath.section == 3 {
            
            if indexPath.row == peopleList.count {
                cell.setup(placeholder: "", title: "")
                cell.setup(placeholder: indexPath.row == 0 ? Text.invitePeople : Text.inviteOtherPeople)
                cell.setup(keyboardReturnKeyType: .done)
                cell.setup(isUserInterfaceEnable: false)
            } else {
                cell.setup(isHideCleareButton: false)
                cell.setup(placeholder: "", title: peopleList[indexPath.row])
            }
            cell.setup(iconImage: indexPath.row == 0 ? "friend-gray" : "")
        } else {
            cell.setup(placeholder: "", title: Text.createGroupChat)
            cell.setup(isShowSwitch: true)
        }
        
        cell.textDidChanged = {  [weak self] (text) in
            guard let self_ = self else { return }
            if indexPath.section == 0 {
                self_.nameClub = text
            } else if indexPath.section == 1 {
                self_.clubDescription = text
            }
            self_.validateAllFields()
        }
        
        cell.textDidEndEditing = { [weak self] (text) in
            guard let self_ = self else { return }
            if indexPath.section == 2 {
                if !self_.interestList.contains(text) {
                    self_.interestList.append(text)
                    self_.tableView.reloadData()
                }
            } else if indexPath.section == 3 {
                if !self_.peopleList.contains(text) {
                    self_.peopleList.append(text)
                    self_.tableView.reloadData()
                }
            }
            self_.validateAllFields()
        }
        
        cell.clearButtonClickEvent = { [weak self] () in
            guard let self_ = self else { return }
            
            if indexPath.section == 2 {
                if let index = self_.interestList.firstIndex(of: (self_.interestList[indexPath.row])) {
                    self_.interestList.remove(at: index)
                    self_.tableView.reloadData()
                }
            } else if indexPath.section == 3 {
                if let index = self_.peopleList.firstIndex(of: (self_.peopleList[indexPath.row])) {
                    self_.peopleList.remove(at: index)
                    self_.tableView.reloadData()
                }
            }
        }
        
        cell.switchValueChanged = { [weak self] (isOn) in
            guard let _ = self else { return }
            
        }
    }
    
    func fillTextViewCell(_ cell: TextViewCell, _ indexPath: IndexPath) {
        
    }
    
    func fillImageHeader(_ view: UserImagesHeaderView) {
        view.setup(image: clubImage)
        view.addPhotoButtonEvent = { [weak self] () in
            guard let self_ = self else { return }
            self_.openCameraOrLibrary(type: .photoLibrary)
            
        }
    }
}

// MARK: - Other functions
extension CreateClubViewController {
    // MARK: - Capture Image
    func openCameraOrLibrary( type : UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            
            if type == .photoLibrary {
                let status = PHPhotoLibrary.authorizationStatus()
                guard status == .authorized else {
                    self.showPermissionAlert(text: Message.phPhotoLibraryAuthorizedMesssage)
                    return
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
        Utils.alert(message: text, title : "Permission Requires", buttons: ["Cancel", "Settings"], handler: { (index) in
            if index == 1 {
                //Open settings
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
    }
    
    func validateAllFields() {
        if clubImage != nil /*&& nameClub.isNotEmpty && clubDescription.isNotEmpty && interestList.count > 0 && peopleList.count > 0*/ {
            navigationItem.rightBarButtonItem = saveBtnActive
        } else {
            navigationItem.rightBarButtonItem = saveBtnActive// saveBtnDisActive
        }
    }
}

// MARK: - UIImagePickerControllerDelegate methods
extension CreateClubViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        autoreleasepool {
            var captureImage = info[UIImagePickerController.InfoKey.originalImage]
                as? UIImage
            if #available(iOS 11, *), captureImage == nil {
                if PHPhotoLibrary.authorizationStatus() == .authorized {
                    let asset                    = info[UIImagePickerController.InfoKey.phAsset] as! PHAsset
                    let manager                  = PHImageManager.default()
                    let requestOptions           = PHImageRequestOptions()
                    requestOptions.isSynchronous = true
                    manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: requestOptions, resultHandler: { (image, info) in
                        if image != nil
                        {
                            captureImage = image
                        }
                    })
                    
                } else {
                    //Show Alert for error
                    showPermissionAlert(text: Message.phPhotoLibraryAuthorizedMesssage)
                }
            }
            
            DispatchQueue.main.async {
                self.clubImage = captureImage
                self.validateAllFields()
                self.tableView.reloadData()
                picker.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}
