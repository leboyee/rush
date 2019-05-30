//
//  EnterPhoneNoViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension EnterPhoneNoViewController {
    
    
}

//MARK:- Custom Picker delegate
extension EnterPhoneNoViewController: CustomPickerDelegate {
    func selectedValue(data: String, type: String) {
        
    }
    
    func selectedCountryValue(countryName: String, countryCode: String) {
        self.phoneNoTextField.text = self.phoneNoTextField.text?.replacingOccurrences(of:"\(self.countryCode)", with: "")
        self.countryCode =  countryCode
        self.flagImage.image = UIImage(named: "\(countryName.replacingOccurrences(of: " ", with: ""))")
        self.phoneNoTextField.text = "\(countryCode)\(phoneNoTextField.text ?? "")"
    }
}
