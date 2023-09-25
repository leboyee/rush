//
//  FontExtension.swift
//  Rush
//
//  Created by Nick Boyer on 24/01/20.
//  Copyright © 2020 Nick Boyer. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    class func regular(sz: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Regular", size: sz)!
    }
    
    class func medium(sz: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Medium", size: sz)!
    }
    
    class func bold(sz: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Bold", size: sz)!
    }
    
    class func heavy(sz: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Heavy", size: sz)!
    }
    
    class func light(sz: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Light", size: sz)!
    }
    
    class func semibold(sz: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Semibold", size: sz)!
    }
    
    class func displayBold(sz: CGFloat) -> UIFont {
        return UIFont(name: "SFProDisplay-Bold", size: sz)!
    }
    
    class func displayLight(sz: CGFloat) -> UIFont {
        return UIFont(name: "SFProDisplay-Light", size: sz)!
    }
    
    class func displaySemibold(sz: CGFloat) -> UIFont {
        return UIFont(name: "SFProDisplay-Semibold", size: sz)!
    }
    
}
