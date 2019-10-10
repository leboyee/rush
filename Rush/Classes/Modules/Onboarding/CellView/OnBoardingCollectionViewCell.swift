//
//  OnBoardingCollectionViewCell.swift
//  Rush
//
//  Created by Suresh Jagnani on 11/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var detailsLable: CustomLabel!
    @IBOutlet weak var onboardImageView: CustomOnboardImageView!
    @IBOutlet weak var topConstraintImageView: NSLayoutConstraint!
    @IBOutlet weak var topTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var topDetailLableContraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones5.rawValue {
                titleLabel.font = UIFont.displaySemibold(sz: 18)
            detailsLable.font = UIFont.regular(sz: 12)
            topDetailLableContraint.constant = 45
        } else if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones6.rawValue {
            titleLabel.font = UIFont.displaySemibold(sz: 23)
            detailsLable.font = UIFont.regular(sz: 15)
            topDetailLableContraint.constant = 10
        } else if UIDevice.current.screenType.rawValue ==  UIDevice.ScreenType.iPhones6Plus.rawValue {
        
        } else {
        
        }
    }
}

extension OnBoardingCollectionViewCell {
    
    func setup(index: Int) {
        switch index {
        case 0:
            titleLabel.text = Text.firstOnboardTitle
            detailsLable.text = Text.firstOnboardDescription
            onboardImageView.image = UIScreen.main.nativeBounds.height > 2208 ? #imageLiteral(resourceName: "illustration-#1") : #imageLiteral(resourceName: "iPhone8_illustration-#1")
        case 1:
            titleLabel.text = Text.secondOnboardTitle
            detailsLable.text = Text.secondOnboardDescription
            onboardImageView.image = UIScreen.main.nativeBounds.height > 2208 ? #imageLiteral(resourceName: "illustration-#2") : #imageLiteral(resourceName: "iPhone8_illustration-#2")
        case 2:
            titleLabel.text = Text.thirdOnboardTitle
            detailsLable.text = Text.thirdOnboardDescription
            onboardImageView.image = UIScreen.main.nativeBounds.height > 2208 ? #imageLiteral(resourceName: "illustration-#3") : #imageLiteral(resourceName: "iPhone8_illustration-#3")
        case 3:
            titleLabel.text = Text.forthOnboardTitle
            detailsLable.text = Text.forthOnboardDescription
            onboardImageView.image = UIScreen.main.nativeBounds.height > 2208 ? #imageLiteral(resourceName: "illustration-#4") : #imageLiteral(resourceName: "iPhone8_illustration-#4")
        default:
            break
        }
    }
}
