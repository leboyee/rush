//
//  CustomLabel.swift
//  Rush
//
//  Created by Suresh Jagnani on 13/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CustomEmailAttributedLabel: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCustomUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupCustomUI() {
        let yourAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.regular(sz: 13)]
        let yourOtherAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.brown24, .font: UIFont.regular(sz: 13)]
        
        let partOne = NSMutableAttributedString(string: "By entering your email, you accept our", attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: " terms and conditions", attributes: yourOtherAttributes)
        let partThree = NSMutableAttributedString(string: " and", attributes: yourAttributes)
        let partFour = NSMutableAttributedString(string: " data policy", attributes: yourOtherAttributes)

        partOne.append(partTwo)
        partOne.append(partThree)
        partOne.append(partFour)
        self.attributedText = partOne
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
