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
import UnsplashPhotoPicker
import PanModal

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
                cell.setup(placeholder: "", text: interestList[indexPath.row].interestName)
            }
            cell.textView.isUserInteractionEnabled = false
            cell.setup(iconImage: indexPath.row == 0 ? "interest-gray" : "")
        } else if indexPath.section == 3 {
            if indexPath.row == peopleList.count {
                cell.setup(placeholder: "", text: "")
                cell.setup(placeholder: indexPath.row == 0 ? Text.invitePeople : Text.inviteOtherPeople)
                cell.setup(isUserInterfaceEnable: false)
            } else {
                let invite = peopleList[indexPath.row]
                cell.setup(isHideCleareButton: false)
                cell.setup(placeholder: "", text: (invite.isFriend == true ? invite.profile?.name : invite.contact?.displayName) ?? "")
            }
            cell.setup(iconImage: indexPath.row == 0 ? "friend-gray" : "")
            cell.textView.isUserInteractionEnabled = false
        } else if indexPath.section == 4 {
            cell.setup(iconImage: "addLocation")
            cell.setup(placeholder: Text.addUniversity, text: selectedUniversity?.universityName ?? "")
            cell.setup(placeholder: Text.addUniversity)
            cell.setup(isHideClearButton: true)
            cell.setup(isEnabled: false)
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
                    /*
                    if !unself.interestList.contains(txt) {
                        unself.interestList.append(txt)
                        unself.tableView.reloadData()
                    }
                    */
                } else if indexPath.section == 3 {
                    /*
                    if !self_.peopleList.contains(txt) {
                        self_.peopleList.append(txt)
                        self_.tableView.reloadData()
                    }
                    */
                }
            }
            unself.validateAllFields()
        }
        
        cell.clearButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            
            if indexPath.section == 2 {
                unself.interestList.remove(at: indexPath.row)
                unself.tableView.reloadData()
            } else if indexPath.section == 3 {
                
                if unself.clubInfo != nil {
                    if let invitee = unself.clubInfo?.invitees {
                        let people = unself.peopleList[indexPath.row]
                        let filter = invitee.filter({ $0.user?.userId == people.profile?.userId })
                        if filter.count > 0 {
                            if let id = people.profile?.userId {
                                if unself.removePeopleIds.contains(id) == false {
                                    unself.removePeopleIds.append(id)
                                }
                            }
                        }
                    }
                }
                
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
        if clubInfo == nil {
            clubHeader.setup(image: clubImage)
        } else {
            clubHeader.setup(url: clubInfo?.clubPhoto?.photo?.url())
        }
        clubHeader.delegate = self
    }
    func downloadPhoto(_ photo: UnsplashPhoto) {
          guard let url = photo.urls[.regular] else { return }
          
          if let cachedResponse = CreateEventViewController.cache.cachedResponse(for: URLRequest(url: url)),
              let image = UIImage(data: cachedResponse.data) {
              clubImage = image
              clubHeader.setup(image: clubImage)
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
                    strongSelf.clubImage = image
                    strongSelf.clubHeader.setup(image: image)
                    strongSelf.tableView.reloadData()
                    strongSelf.validateAllFields()
                }, completion: nil)
              }
          }
          
          imageDataTask?.resume()
      }
     func loadCountryJson() {
         if let path = Bundle.main.path(forResource: "CountryPhoneCode", ofType: "json") {
             do {
                 let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                 let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                 if let jsonResult = jsonResult as? [[String: Any]] {
                     countryCode = jsonResult
                 }
             } catch { }
         }
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
        if ((clubImage != nil && clubInfo == nil) || clubInfo != nil) && nameClub.isNotEmpty && clubDescription.isNotEmpty && interestList.count > 0 && peopleList.count > 0 && selectedUniversity != nil {
            saveButton.isEnabled = true
            saveButton.setImage(#imageLiteral(resourceName: "save-active"), for: .normal)
        } else {
            // saveBtnDisActive
            saveButton.isEnabled = false
            saveButton.setImage(#imageLiteral(resourceName: "save-dark"), for: .normal)
        }
    }
}

// MARK: - UnsplashPhotoPickerDelegate
extension CreateClubViewController: UnsplashPhotoPickerDelegate {
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
// MARK: - SelectEventTypeController Delegate
extension CreateClubViewController: SelectEventTypeDelegate {
    func createEventClub(_ type: EventType, _ screenType: ScreenType) {
//        self.eventType = type
        validateAllFields()
    }
    
    func addPhotoEvent(_ type: PhotoFrom) {
//         self.openCameraOrLibrary(type: .photoLibrary)
      if type == .cameraRoll {
            self.openCameraOrLibrary(type: .photoLibrary, isFromUnsplash: false)
        } else {
            self.openCameraOrLibrary(type: .photoLibrary, isFromUnsplash: true)
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
        
        let friendArray = self.peopleList.filter { ($0.isFriend == true) }
        let userIdArray = friendArray.compactMap { ($0.profile?.userId) }
        
        let img = clubImage?.wxCompress()
        let dataN = img?.jpegData(compressionQuality: 1) ?? Data()
        
        let interests = interestList.compactMap({ "\($0.interestId)" }).joined(separator: ",")
        
        guard let countryCodeString = (Locale.current as NSLocale).object(forKey: .countryCode) as? String else {
                   return }
               print(countryCodeString)
               let contactList = self.peopleList.filter { ($0.isFriend == false) }
               let contactArray = contactList.compactMap { ($0.contact?.phone) }
               var contactDict = [String: Any]()
               var newContactArray = [[String: Any]]()
               for contact in contactArray {
                   guard let index = countryCode.firstIndex(where: { $0["code"] as? String == countryCodeString }) else { return }
                   let countryNumberCodeString = countryCode[index]["dial_code"] as? String ?? ""
                   var contactString = ""
                   if contact.contains("+") {
                       contactString = contact
                   } else {
                       contactString = "\(countryNumberCodeString)\(contact)"
                   }
                   if contactString.count >= 10 {
                       contactDict["cc"] = countryNumberCodeString
                       contactDict["phone"] = contactString
                       newContactArray.append(contactDict)
                   }
               }
               
               var jsonString = ""
               do {
                   let jsonData = try JSONSerialization.data(withJSONObject: newContactArray)
                   if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                       jsonString = JSONString
                   }
               } catch {
                   print(error.localizedDescription)
               }
        
        let param = [Keys.clubName: nameClub,
                     Keys.clubDesc: clubDescription,
                     Keys.clubInterests: interests,
                     Keys.clubInvitedUserIds: userIdArray.joined(separator: ","),
                     Keys.clubContact: jsonString,
                     Keys.clubIsChatGroup: isCreateGroupChat ? 1 : 0,
                     Keys.clubUniversityId: selectedUniversity?.universtiyId ?? 0,
                     Keys.clubPhoto: dataN] as [String: Any]
        
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
    
    func updateClubAPI() {
        
        let interests = interestList.compactMap({ "\($0.interestId)" }).joined(separator: ",")
        
        let ids = removePeopleIds
        for removeId in ids {
            let filter = peopleList.filter({ $0.profile?.userId == removeId })
            if filter.count > 0 {
                if let index = ids.firstIndex(of: removeId) {
                    removePeopleIds.remove(at: index)
                }
            }
        }
        
        if let invitees = clubInfo?.invitees {
            for newPeopleId in newPeopleIds {
                let filter = invitees.filter({ $0.user?.userId == newPeopleId })
                if filter.count > 0 {
                    if let index = ids.firstIndex(of: newPeopleId) {
                        newPeopleIds.remove(at: index)
                    }
                }
            }
        }
        
        let removeIds = removePeopleIds.joined(separator: ",")
        
        guard let countryCodeString = (Locale.current as NSLocale).object(forKey: .countryCode) as? String else {
            return }
        print(countryCodeString)
        let contactArray = newContacts.compactMap { ($0) }
        var contactDict = [String: Any]()
        var newContactArray = [[String: Any]]()
        for contact in contactArray {
            guard let index = countryCode.firstIndex(where: { $0["code"] as? String == countryCodeString }) else { return }
            let countryNumberCodeString = countryCode[index]["dial_code"] as? String ?? ""
            var contactString = ""
            if contact.contains("+") {
                contactString = contact
            } else {
                contactString = "\(countryNumberCodeString)\(contact)"
            }
            if contactString.count >= 10 {
                contactDict["cc"] = countryNumberCodeString
                contactDict["phone"] = contactString
                newContactArray.append(contactDict)
            }
        }
        
        var jsonString = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: newContactArray)
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                jsonString = JSONString
            }
        } catch {
            print(error.localizedDescription)
        }
        
        var param = [Keys.clubId: clubInfo?.id ?? 0,
                     Keys.clubName: nameClub,
                     Keys.clubDesc: clubDescription,
                     Keys.clubInterests: interests,
                     Keys.clubInvitedUserIds: newPeopleIds.joined(separator: ","),
                     Keys.removedClubInvitedUserIds: removeIds,
                     Keys.clubUniversityId: selectedUniversity?.universtiyId ?? 0,
                     Keys.clubContact: jsonString,
                     Keys.clubIsChatGroup: isCreateGroupChat ? 1 : 0] as [String: Any]
        
        if clubHeader.userImageView.image != nil {
            let img = clubHeader.userImageView.image
            let dataN = img?.jpegData(compressionQuality: 1) ?? Data()
            param[Keys.clubPhoto] = dataN
        }
        
        Utils.showSpinner()
        ServiceManager.shared.updateClub(clubId: clubInfo?.clubId ?? "0", params: param) { [weak self] (data, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            
            if data != nil {
                unsafe.delegate?.updateClubSuccess()
                unsafe.dismiss(animated: false, completion: nil)
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
