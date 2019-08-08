//
//  RSeparatorLine.swift
//  Rush
//
//  Created by kamal on 08/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class RSeparatorLine: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCustomUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupCustomUI() {
        backgroundColor = isDarkModeOn ? UIColor.separatorColorDark : UIColor.separatorColor
    }

}
