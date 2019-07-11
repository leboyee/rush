//
//  ClubListLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ChatsViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return 4
    }
    
    func fillCell(_ cell: SearchClubCell, _ indexPath: IndexPath) {
        
    }
    
    func cellSelected(_ indexPath: IndexPath) {
        
    }
}

extension ChatsViewController: UITextFieldDelegate {
    @objc func textDidChange(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Utils.notReadyAlert()
        textField.resignFirstResponder()
        return true
    }
}
