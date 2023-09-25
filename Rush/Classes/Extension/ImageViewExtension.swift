//
//  ImageViewExtension.swift
//  eventX_ios
//
//  Created by Nick Boyer on 24/01/20.
//  Copyright © 2020 Nick Boyer. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func rotate360Degrees(duration: CFTimeInterval = 0.7, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        //rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = 2 * CGFloat.pi
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = .greatestFiniteMagnitude
        layer.add(rotateAnimation, forKey: "rotate360")
    }
    
    func stop360Degrees() {
        layer.removeAnimation(forKey: "rotate360")
    }
}
