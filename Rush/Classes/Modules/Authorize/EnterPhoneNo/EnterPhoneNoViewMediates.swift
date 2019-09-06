//
//  EnterPhoneNoViewMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension EnterPhoneNoViewController: UITextFieldDelegate {
    
    func setupMediator() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        phoneNoTextField.delegate = self
        phoneNoTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

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
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNoTextField {
            guard let text = textField.text else { return true }
            let fullText = (text as NSString).replacingCharacters(in: range, with: string)
            return checkLengthLimit(forText: fullText, inTextField: textField)
        } else {
            return false
        }
       
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.count == frontTextFiled.count {
            setPlaceHolder()
        }
        
        if textField.text?.count == (frontTextFiled.count + 1) {
            placeHolderTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.clear])
        }
        
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        let textValidation = textField.text?.replacingOccurrences(of: countryCode, with: "")
        let validateResult = self.validatePhoneNumber(textValidation ?? "")
        phoneNoTextField.text = "\(self.frontTextFiled)\(validateResult.formatted)"
        if (textField.text?.count ?? 0) >= (10 + self.frontTextFiled.count) {
            nextButton.setNextButton(isEnable: true)
        } else {
            nextButton.setNextButton(isEnable: false)
        }
    }
    
    fileprivate func checkLengthLimit(forText text: String,
                                      inTextField textField: UITextField) -> Bool {
        if textField == phoneNoTextField {
            var maxLength = 100
            if textField == phoneNoTextField {
                maxLength = (13 + self.frontTextFiled.count)
            }
            return text.count <= maxLength
        } else {
            return false
        }
       
    }

    func validatePhoneNumber(_ phoneNo: String) -> (formatted: String, valid: Bool) {
        var formatted = ""
        let nsDateString = phoneNo as NSString
        let numberOnly = nsDateString.replacingOccurrences(of: "[^0-9]",
                                                           with: "",
                                                           options: .regularExpression,
                                                           range: NSMakeRange(0, nsDateString.length))
        
        var formatted2 = ""
        var counter = 0
        
        for char in numberOnly {
            if counter == 0 {
                //formatted2.append("-(")
            }
            if counter < 12 {
                if counter < 6 {
                    if formatted2.count == 3 {
                        formatted += formatted2 + ")-"
                        formatted2 = ""
                    }
                }
                if counter >= 6 && counter < 8 {
                        if formatted2.count == 3 {
                            formatted += formatted2 + "-"
                            formatted2 = ""
                        }
                    }
                }
            formatted2.append(char)
            counter += 1
        }
        
        formatted += formatted2
        return (formatted, true)
    }
}
