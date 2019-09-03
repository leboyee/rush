//
//  ChooseYearViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ChooseYearViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
            return 56
    }
    
    func cellCount(_ section: Int) -> Int {
        return Utils.chooseYearArray().count
    }
    
    func fillChooseYearCell(_ cell: ListCell, _ indexPath: IndexPath) {
        cell.setup(title:Utils.chooseYearArray()[indexPath.row])
        cell.setup(checkMark: selectedIndex == indexPath.row ? true : false)
    }
}

//MARK: - Manage Interator or API's Calling
extension ChooseYearViewController {
    
    func updateProfileAPI() {
        
        let param = [Keys.uEduYear: Utils.chooseYearArray()[selectedIndex]]  as [String : Any]
        
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
