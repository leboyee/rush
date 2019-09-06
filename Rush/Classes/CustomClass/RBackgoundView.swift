//
//  RBackgoundView.swift
//  Rush
//
//  Created by kamal on 08/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class RBackgoundView: UIView {

    let radius: CGFloat = 32.0
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCustomUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupCustomUI() {
         layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
         layer.cornerRadius = radius
         backgroundColor = isDarkModeOn ? UIColor.bgBlack17 : UIColor.bgWhite96
    }
    
    func roundAllCorners(with radius: CGFloat) {
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        layer.cornerRadius = radius
        backgroundColor = isDarkModeOn ? UIColor.bgBlack17 : UIColor.bgWhite96
    }
}
