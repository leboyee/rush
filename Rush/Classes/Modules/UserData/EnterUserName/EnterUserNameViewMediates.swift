//
//  EnterUserNameViewMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit


extension EnterUserNameViewController: UITextFieldDelegate {
    
    func setupMediator() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)


    }
    
    //MARK: - Keyboard functions
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            if UIDevice.current.screenType.rawValue != UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue  {
                bottomViewConstraint.constant = keyboardHeight + 10
                self.view.layoutIfNeeded()

            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
     //   if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        if UIDevice.current.screenType.rawValue != UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue  {
            bottomViewConstraint.constant = 30
            self.view.layoutIfNeeded()

        }
       // }
    }

    
    

    
    //MARK : UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count == 0 && string == " "{
            return false
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if firstNameTextField.text?.count ?? 0 > 0 && lastNameTextField.text?.count ?? 0 > 0 {
            self.nextButton.setNextButton(isEnable: true)
        }
        else {
            self.nextButton.setNextButton(isEnable: false)
        }
    }
}


