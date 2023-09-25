//
//  TapGestureExtension.swift
//  Friends
//
//  Created by Nick Boyer on 24/01/20.
//  Copyright © 2020 Nick Boyer. All rights reserved.
//

import Foundation
import UIKit

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        
        let attributedText = NSMutableAttributedString(attributedString: label.attributedText!)
        attributedText.addAttributes([.font: label.font!], range: NSRange(location: 0, length: attributedText.string.count))
        let textStorage = NSTextStorage(attributedString: attributedText)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
       
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: (locationOfTouchInLabel.x - textContainerOffset.x), y: (locationOfTouchInLabel.y - textContainerOffset.y))
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if NSLocationInRange(indexOfCharacter, targetRange) {
            return true
        } else {
            // increasse tap area
            // +2 for increase tap area at start
            let range = NSRange(location: targetRange.location, length: targetRange.length + 2)
            if NSLocationInRange(indexOfCharacter, range) {
               return true
            } else {
               return NSLocationInRange(indexOfCharacter + 2, range)
            }
        }
    }
    
}
