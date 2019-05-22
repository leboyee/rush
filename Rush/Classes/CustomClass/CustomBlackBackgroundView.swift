//
//  CustomBlackBackgroundView.swift
//  Rush
//
//  Created by ideveloper on 16/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CustomBlackBackgroundView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCustomUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupCustomUI() {
        self.backgroundColor = isDarkModeOn ? UIColor.bgBlack : UIColor.white
    }
}
