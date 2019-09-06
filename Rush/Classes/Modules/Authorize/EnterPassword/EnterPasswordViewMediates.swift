//
//  EnterPasswordViewMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension EnterPasswordViewConteroller: UITextFieldDelegate {
    
    func setupMediator() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }
    
    // MARK: - Keyboard functions
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            bottomViewConstraint.constant = keyboardHeight + 10
            self.view.layoutIfNeeded()
            
        }
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        passwordShowHideLabel.isHidden = textField.text?.count == 0 ? true : false
        if self.loginType == .register {
            capitalLetterDotView.setPasswordDotColorView(index: textField.text?.count == 0 ? .none : textField.text?.isCapitalLater == true ? .correct : .wrong)
            numberDotView.setPasswordDotColorView(index: textField.text?.count == 0 ? .none : textField.text?.isNumberLater == true ? .correct : .wrong)
            symbolDotView.setPasswordDotColorView(index: textField.text?.count == 0 ? .none : (textField.text?.count ?? 0) >= 8 ? .correct : .wrong)
            if (textField.text?.count ?? 0) >= 8  && textField.text?.isNumberLater == true && textField.text?.isCapitalLater == true {
                nextButton.setNextButton(isEnable: true)
            } else {
                nextButton.setNextButton(isEnable: false)
            }
        } else {
            nextButton.setNextButton(isEnable: textField.text?.count == 0 ? false : true)
        }
    }
}
