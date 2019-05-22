//
//  OnBoardingCollectionViewCell.swift
//  PaidMeals
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
        
       if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue  {
                titleLabel.font = UIFont.DisplaySemibold(sz: 18)
            detailsLable.font = UIFont.Regular(sz: 12)

        
        } else if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones_6_6s_7_8.rawValue  {
            titleLabel.font = UIFont.DisplaySemibold(sz: 23)
          detailsLable.font = UIFont.Regular(sz: 15)
        
        } else if UIDevice.current.screenType.rawValue ==  UIDevice.ScreenType.iPhones_6Plus_6sPlus_7Plus_8Plus.rawValue  {
        
        }
        else   {
        
        }
    }
}

extension OnBoardingCollectionViewCell {
    
    
    func setup(index: Int) {
      
        switch index {
        case 0:
            titleLabel.text = Text.firstOnboardTitle
            detailsLable.text = Text.firstOnboardDescription
            onboardImageView.image =  #imageLiteral(resourceName: "iphone6-img")
            break
        case 1:
            titleLabel.text = Text.secondOnboardTitle
            detailsLable.text = Text.secondOnboardDescription
            onboardImageView.image =  #imageLiteral(resourceName: "Onboarding2")

            break
        case 2:
            titleLabel.text = Text.thirdOnboardTitle
            detailsLable.text = Text.thirdOnboardDescription
            onboardImageView.image =  #imageLiteral(resourceName: "Onboarding3")

            break
        case 3:
            titleLabel.text = Text.forthOnboardTitle
            detailsLable.text = Text.forthOnboardDescription
            onboardImageView.image =  #imageLiteral(resourceName: "Onboarding4")
            break
        default:
            break
            
        }

    }
    
}
