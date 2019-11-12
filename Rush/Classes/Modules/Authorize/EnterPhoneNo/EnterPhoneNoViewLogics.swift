//
//  EnterPhoneNoViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension EnterPhoneNoViewController {
    
    func setPlaceHolder() {

        let yourAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.clear, .font: UIFont.displayBold(sz: UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones5.rawValue ? 18 : 25)]
        
        let blackArrtibutes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.displayBold(sz: UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones5.rawValue ? 18 : 25)]

        let yourOtherAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray84, .font: UIFont.displayBold(sz: UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones5.rawValue ? 18 : 25)]
        
        let partOne = NSMutableAttributedString(string: "\(self.countryCode)-(", attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: "541", attributes: yourOtherAttributes)
        let partThree = NSMutableAttributedString(string: ")", attributes: blackArrtibutes)
        let partFour = NSMutableAttributedString(string: "-754-3010", attributes: yourOtherAttributes)
        
        partOne.append(partTwo)
        partOne.append(partThree)
        partOne.append(partFour)
        placeHolderTextField.attributedPlaceholder = partOne
        phoneNoTextField.font = UIFont.displayBold(sz: UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones5.rawValue ? 18 : 25)
    }
    
    func setContryCodeWith() {
        self.frontTextFiled = "\(self.countryCode)-("
    }
    
}

// MARK: - Custom Picker delegate
extension EnterPhoneNoViewController: CustomPickerDelegate {
    func selectedValue(data: String, type: String) {
        
    }
    
    func selectedCountryValue(countryName: String, countryCode: String) {
        self.phoneNoTextField.text = self.phoneNoTextField.text?.replacingOccurrences(of: "\(self.frontTextFiled)", with: "")
        self.countryCode =  countryCode
        self.flagImage.image = UIImage(named: "\(countryName.replacingOccurrences(of: " ", with: ""))")
        setContryCodeWith()
        self.phoneNoTextField.text = "\(self.frontTextFiled)\(phoneNoTextField.text ?? "")"

        if phoneNoTextField.text?.count == frontTextFiled.count {
            setPlaceHolder()
        }
    }
}

extension EnterPhoneNoViewController {
    /*
     * Get SMS code and register Phone
     */
    func authPhone() {
        Utils.showSpinner()
        let verifyTye = loginType == .register ? "signup" : "login"
        let countryCodeString = self.countryCode.replacingOccurrences(of: "+", with: "")
        var phoneString = self.phoneNoTextField.text?.replacingOccurrences(of: self.countryCode, with: "") ?? ""
        phoneString = phoneString.replacingOccurrences(of: "+", with: "")
        phoneString = phoneString.replacingOccurrences(of: "-", with: "")
        phoneString = phoneString.replacingOccurrences(of: "(", with: "")
        phoneString = phoneString.replacingOccurrences(of: ")", with: "")
        profile.phone = phoneString
        profile.countryCode = countryCodeString
        let param = [Keys.countryCode: countryCodeString, Keys.phone: phoneString, Keys.verifyType: verifyTye]
        ServiceManager.shared.authPhone(params: param) { [weak self] (status, errorMessage) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if status {
               unsafe.moveToVerificationView()
            } else {
                Utils.alert(message: errorMessage ?? "Please contact Admin")
            }
        }
    }
}
