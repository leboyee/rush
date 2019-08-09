//
//  RSwitch.swift
//  Rush
//
//  Created by kamal on 09/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class RSwitch: UISwitch {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCustomUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupCustomUI() {
        onTintColor = isDarkModeOn ? UIColor.white : UIColor.brown24
    }


}
