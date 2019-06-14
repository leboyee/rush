//
//  CreatePostLogics.swift
//  Rush
//
//  Created by ideveloper2 on 12/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension CreatePostViewController {
    
    func cellHeight(_ indexPath:IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }else if indexPath.section == 1 {
            return UITableView.automaticDimension
        }else {
            return 375
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            viewBottamConstraint.constant = keyboardSize.size.height + 40
        }
    }

    
    @objc func keyboardWillHide(notification: NSNotification) {
        viewBottamConstraint.constant = 20
    }
    
}

