//
//  FontExtension.swift
//  PaidMeals
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    class func Regular(sz : CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Regular", size: sz)!
    }
    
    class func Medium(sz : CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Medium", size: sz)!
    }
    
    class func Bold(sz : CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Bold", size: sz)!
    }
    
    class func Heavy(sz : CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Heavy", size: sz)!
    }
    
    class func Light(sz : CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Light", size: sz)!
    }
    
    class func Semibold(sz : CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Semibold", size: sz)!
    }
    
    class func DisplayBold(sz : CGFloat) -> UIFont {
        return UIFont(name: "SFProDisplay-Bold", size: sz)!
    }
    
    class func DisplayLight(sz : CGFloat) -> UIFont {
        return UIFont(name: "SFProDisplay-Light", size: sz)!
    }
    
    class func DisplaySemibold(sz : CGFloat) -> UIFont {
        return UIFont(name: "SFProDisplay-Semibold", size: sz)!
    }
    
}
