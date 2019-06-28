//
//  CustomBlackLabel.swift
//  Rush
//
//  Created by ideveloper on 16/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CustomBlackButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCustomUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupCustomUI() {
        self.setTitleColor(isDarkModeOn ? UIColor.white : UIColor.bgBlack, for: .normal)
    }
}
