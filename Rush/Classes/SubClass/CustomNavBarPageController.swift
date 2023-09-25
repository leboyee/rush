//
//  CustomNavBarPageController.swift
//  Rush
//
//  Created by Nick Boyer on 24/01/20.
//  Copyright © 2020 Nick Boyer. All rights reserved.
//

import UIKit

class CustomNavBarPageController: UIView {
    
    @IBOutlet weak var pageControl: CustomImagePageControl!
    @IBOutlet weak var skipButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControllerLeadingConstraint: NSLayoutConstraint!
    var view: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        pageControl.isSteps = true
    }
    
    override func layoutSubviews() {
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones5.rawValue { }
    }
    
    func instanceFromNib() -> UIView {
        let view = UINib(nibName: "CustomNavBarPageController", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView
        return view ?? UIView()
    }
}
