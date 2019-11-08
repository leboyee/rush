//
//  AddProfilePictureViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension AddProfilePictureViewController {
}

// MARK: - Manage Interator or API's Calling
extension AddProfilePictureViewController {
    
    func updateProfileAPI() {
        var photoData = Data()
        if (userPhotoImageView.image ?? UIImage()).size.width > 0 {
            photoData = userPhotoImageView.image?.jpegData(compressionQuality: 0.8) ?? Data()
        }

        let param = ["u_photo": photoData] as [String: Any]
        
        Utils.showSpinner()
        ServiceManager.shared.uploadUserProfileImage(params: param) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if data != nil {
                AppDelegate.shared?.updateUserChatProfilePicture()
                unsafe.profileUpdateSuccess()
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
