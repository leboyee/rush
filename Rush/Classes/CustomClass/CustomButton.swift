//
//  CustomLabel.swift
//  Rush
//
//  Created by Suresh Jagnani on 13/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCustomUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupCustomUI() {
      
    }

    func setNextButton(isEnable: Bool) {
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true        
        if isEnable == true {
            self.isEnabled = isEnable
            self.backgroundColor =  UIColor.brown24
            self.setTitleColor(UIColor.white, for: .normal)
        }
        else {
            self.isEnabled = isEnable
            self.backgroundColor =  UIColor.buttonDisableBgColor
            self.setTitleColor(UIColor.buttonDisableTextColor, for: .normal)
        }
    }
    
    func setEmailErrorButton() {
        self.setImage(#imageLiteral(resourceName: "delete-gray"), for: .normal)
    }
    
    func setLoginWithNumberButton() {
        self.setTitleColor(UIColor.lightGrayColor, for: .normal)
    }
}
