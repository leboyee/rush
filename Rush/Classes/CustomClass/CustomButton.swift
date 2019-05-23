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
        setNextButton(isEnable: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupCustomUI() {
      
    }

    func setNextButton(isEnable: Bool) {
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        self.backgroundColor =  UIColor.brown24
        self.setTitleColor(UIColor.white, for: .normal)
        /*
        if isEnable == true {
            self.backgroundColor =  UIColor.brown24
            self.setTitleColor(UIColor.white, for: .normal)
        }
        else {
            self.backgroundColor =  UIColor.buttonDisableBgColor
            self.setTitleColor(UIColor.buttonDisableTextColor, for: .normal)
        }*/
    }
    
    func setEmailErrorButton() {
        self.backgroundColor =  UIColor.clear

    }
    

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
