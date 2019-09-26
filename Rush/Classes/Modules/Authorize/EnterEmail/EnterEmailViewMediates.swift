//
//  EnterEmailViewMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension EnterEmailViewConteroller: UITextFieldDelegate {
    
    func setupMediator() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }
    // MARK: - Keyboard functions
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            bottomViewConstraint.constant = keyboardHeight + 10
            self.view.layoutIfNeeded()
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomViewConstraint.constant = 30
        self.view.layoutIfNeeded()
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length > 0  && range.location >= ((textField.text?.count ?? 0) - 4) {
            return false
        }
        let currentString: NSString = textField.text! as NSString
        let newString =
            currentString.replacingCharacters(in: range, with: string) as String
        var newEmail = newString
        let edu = ".edu.edu"
        if let range = newString.range(of: edu) {
            newEmail.removeSubrange(range)
            textField.text = "\(newEmail).edu"
            if let newPosition = textField.position(from: textField.endOfDocument, in: UITextLayoutDirection.left, offset: 4) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
            return false
        }

        return true
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if isEmailError == true {
            isEmailError = false
            nextButton.setNextButton(isEnable: true)
        }
        if textField.text == ".edu" {
            textField.text = ""
            eduLabel.text = ".edu"
            eduLabel.isHidden = false
            self.view.layoutIfNeeded()
            nextButton.setNextButton(isEnable: false)
        } else {
            if textField.text?.count == 1 {
                eduLabel.text = " .edu"
                eduLabel.isHidden = true
                textField.text = "\(textField.text ?? "").edu"
                if let newPosition = textField.position(from: textField.endOfDocument, in: UITextLayoutDirection.left, offset: 4) {
                    textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
                }

                nextButton.setNextButton(isEnable: true)
                self.view.layoutIfNeeded()
            }
            if textField.text?.count == 0 {
                nextButton.setNextButton(isEnable: false)
                eduLabel.text = ".edu"
                eduLabel.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
    }
}
