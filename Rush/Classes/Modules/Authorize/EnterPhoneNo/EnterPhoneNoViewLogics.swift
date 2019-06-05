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

        let yourAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.DisplayBold(sz: UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue ? 22 : 28)]
        let yourOtherAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray84, .font: UIFont.DisplayBold(sz: UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue ? 22 : 28)]
        
        let partOne = NSMutableAttributedString(string: "\(self.countryCode)-(", attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: "541", attributes: yourOtherAttributes)
        let partThree = NSMutableAttributedString(string: ")", attributes: yourAttributes)
        let partFour = NSMutableAttributedString(string: "-754-3010", attributes: yourOtherAttributes)
        
        partOne.append(partTwo)
        partOne.append(partThree)
        partOne.append(partFour)
        placeHolderTextField.attributedPlaceholder = partOne
        
        phoneNoTextField.font = UIFont.DisplayBold(sz: UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue ? 22 : 28)
    }
    
    func setContryCodeWith() {
        self.frontTextFiled = "\(self.countryCode)-("
    }
    
}

//MARK:- Custom Picker delegate
extension EnterPhoneNoViewController: CustomPickerDelegate {
    func selectedValue(data: String, type: String) {
        
    }
    
    func selectedCountryValue(countryName: String, countryCode: String) {
        self.phoneNoTextField.text = self.phoneNoTextField.text?.replacingOccurrences(of:"\(self.frontTextFiled)", with: "")
        self.countryCode =  countryCode
        self.flagImage.image = UIImage(named: "\(countryName.replacingOccurrences(of: " ", with: ""))")
        setContryCodeWith()
        self.phoneNoTextField.text = "\(self.frontTextFiled)\(phoneNoTextField.text ?? "")"
        if phoneNoTextField.text?.count == frontTextFiled.count {
            setPlaceHolder()
        }

        
    }
}
