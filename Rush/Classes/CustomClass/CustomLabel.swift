//
//  CustomLabel.swift
//  Rush
//
//  Created by Suresh Jagnani on 13/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func emailErrorSetColor() {
        self.textColor = UIColor.lightGrayColor
    }
    
    func emailScreenTitleLabel() {
        self.textColor = UIColor.black
    }
    
    func passwordShowHideLabel() {
        self.textColor = UIColor.buttonDisableTextColor
    }
    
    func passwordFormateLabels() {
        self.textColor = UIColor.lightGray13
    }
    
    func setSkipLevelOnChooseLevelView() {
        self.textColor = UIColor.white
    }


    
    

}
