//
//  ChooseLevelViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ChooseLevelViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
            return 56
    }
    
    func cellCount(_ section: Int) -> Int {
        return Utils.chooseLevelArray().count
    }
    
    func fillChooseLevelCell(_ cell: ListCell, _ indexPath: IndexPath) {
        cell.setup(title: Utils.chooseLevelArray()[indexPath.row])
        cell.setup(checkMark: selectedIndex == indexPath.row ? true : false)
    }
}

// MARK: - Manage Interator or API's Calling
extension ChooseLevelViewController {
    
    func updateProfileAPI() {
        
        var param = [Keys.uEduLevel: Utils.chooseLevelArray()[selectedIndex]] as [String: Any]
        if isEditUserProfile == true {
            if self.selectedIndex > 2 {
                param[Keys.uEduYear] = ""
            }
        }
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
