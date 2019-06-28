//
//  CustomBlackLabel.swift
//  Rush
//
//  Created by ideveloper on 16/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CustomBlackTextView: UITextView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCustomUI()
    }
    
    func setupCustomUI() {
        self.textColor = isDarkModeOn ? UIColor.white : UIColor.bgBlack
    }
}
