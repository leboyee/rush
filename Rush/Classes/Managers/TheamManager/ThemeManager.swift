//
//  TheamManager.swift
//  Rush
//
//  Created by kamal on 09/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ThemeManager: NSObject {

     static let shared = ThemeManager()
    
    
    func loadTheme() {
        
        if isDarkModeOn {
            CustomBlackLabel.appearance().textColor = UIColor.white
            RBackgoundView.appearance().backgroundColor = UIColor.bgBlack17
            RSwitch.appearance().onTintColor = UIColor.white
            RSeparatorLine.appearance().backgroundColor = UIColor.separatorColorDark
            CustomBrownLabel.appearance().textColor = UIColor.white
            TextCell.appearance().backgroundColor = UIColor.separatorColorDark
            RRedArrowImageView.appearance().isHighlighted = true

        } else {
            CustomBlackLabel.appearance().textColor = UIColor.bgBlack
            RBackgoundView.appearance().backgroundColor = UIColor.bgWhite96
            RSwitch.appearance().onTintColor = UIColor.brown24
            RSeparatorLine.appearance().backgroundColor = UIColor.separatorColor
            CustomBrownLabel.appearance().textColor = UIColor.brown24
            TextCell.appearance().backgroundColor = UIColor.white
            RRedArrowImageView.appearance().isHighlighted = false
        }
        
        UIApplication.shared.windows.forEach { window in
            window.subviews.forEach({ view in
                view.removeFromSuperview()
                window.addSubview(view)
            })
        }
    }
}
