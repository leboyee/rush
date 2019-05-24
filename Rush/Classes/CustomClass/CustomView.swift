//
//  CustomView.swift
//  Rush
//
//  Created by Suresh Jagnani on 28/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CustomView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func setPasswordDotColorView(index: passwordFormate) {
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        switch index {
        case .none :
            self.backgroundColor = UIColor.buttonDisableBgColor
        break
        case .correct :
            self.backgroundColor = UIColor.green24
        break
        case .wrong :
            self.backgroundColor = UIColor.brown72
        break
            
        }
        
    }

}
