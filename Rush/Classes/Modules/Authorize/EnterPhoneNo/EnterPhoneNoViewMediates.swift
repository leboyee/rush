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
    
    //MARK: - Keyboard functions
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            bottomViewConstraint.constant = keyboardHeight + 10
            self.view.layoutIfNeeded()
        }
    }

    
    //MARK : UITextFieldDelegate
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
        guard let text = textField.text else {return true}
        let fullText = (text as NSString).replacingCharacters(in: range, with: string)
        return checkLengthLimit(forText: fullText, inTextField: textField)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        if (textField.text?.count ?? 0) >= (15 + countryCode.count)  {
            nextButton.setNextButton(isEnable: true)
        }
        else {
            nextButton.setNextButton(isEnable: false)
        }
        let textValidation = textField.text?.replacingOccurrences(of: countryCode, with: "")
        let validateResult = self.validatePhoneNumber(textValidation ?? "")
        phoneNoTextField.text = "\(countryCode)\(validateResult.formatted)"
        

    }
    
    fileprivate func checkLengthLimit(forText text: String,
                                      inTextField textField: UITextField) -> Bool {
        var maxLength = 100
        if textField == phoneNoTextField {
            maxLength = (15 + countryCode.count)
        }
        return text.count <= maxLength
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
                formatted2.append("-(")
            }
            if counter < 12 {
                if counter < 6 {
                    if formatted2.count == 5 {
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
            counter = counter + 1
        }
        
        formatted += formatted2
        return (formatted, true)
    }

}


