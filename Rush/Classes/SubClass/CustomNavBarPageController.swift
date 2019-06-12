//
//  CustomNavBarPageController.swift
//  Rush
//
//  Created by Suresh Jagnani on 07/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CustomNavBarPageController: UIView {
    
    @IBOutlet weak var pageControl: CustomImagePageControl!
    @IBOutlet weak var skipButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControllerLeadingConstraint: NSLayoutConstraint!
    
    var view : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        pageControl.isSteps = true
    }
    
    override func layoutSubviews() {
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue  {
        }
    }
    
    func instanceFromNib() -> UIView {
        let view = UINib(nibName: "CustomNavBarPageController", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        return view
    }

}

