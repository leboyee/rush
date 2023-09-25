//
//  DeviceExtension.swift
//  Rush
//
//  Created by Nick Boyer on 24/01/20.
//  Copyright © 2020 Nick Boyer. All rights reserved.
//

import UIKit

extension UIDevice {
    
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    enum ScreenType: String {
        case iPhone4 = "iPhone 4 or iPhone 4S"
        case iPhones5 = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones6 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones6Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X or XS"
        case iPhoneXR = "iPhone XR"
        case iPhoneXSMax = "iPhone XS Max"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhones5
        case 1334:
            return .iPhones6
        case 1920, 2208:
            return .iPhones6Plus
        case 2436:
            return .iPhoneX
        case 1792:
            return .iPhoneXR
        case 2688:
            return .iPhoneXSMax
        default:
            return .unknown
        }
    }
    
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
