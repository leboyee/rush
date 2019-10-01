//
//  AkiraTextField.swift
//  TextFieldEffects
//
//  Created by Mihaela Miches on 5/31/15.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

/**
 An AkiraTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the edges of the control.
 */
@IBDesignable open class AkiraTextField: TextFieldEffects {
    private let textFieldInsets = CGPoint(x: 0, y: 0)
    //Update My Kamal Mittal
    private let placeholderInsets = CGPoint(x: 0, y: 0)
    var placeholderColor = UIColor.placeholderColor {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    open var withAnimation: Bool = true
    
    // MARK: TextFieldEffect
    override open func drawViewsForRect(_ rect: CGRect) {
        updatePlaceholder()
        addSubview(placeholderLabel)
    }
    
    override open func animateViewsForTextEntry() {
        if withAnimation {
            UIView.animate(withDuration: 0.3, animations: {
                self.updatePlaceholder()
            }, completion: { _ in
                self.animationCompletionHandler?(.textEntry)
            })
        } else {
            self.updatePlaceholder()
            self.animationCompletionHandler?(.textEntry)
        }
    }
    
    override open func animateViewsForTextDisplay() {
        UIView.animate(withDuration: 0.3, animations: {
            self.updatePlaceholder()
        }, completion: { _ in
            self.animationCompletionHandler?(.textDisplay)
        })
    }
    
    // MARK: Private
    
    private func updatePlaceholder() {
        placeholderLabel.frame = placeholderRect(forBounds: bounds)
        placeholderLabel.text = placeholder
        placeholderLabel.font = placeholderFontFromFont(font!)
        placeholderLabel.textColor = (isFirstResponder || text!.isNotEmpty) ? .black : placeholderColor
        placeholderLabel.textAlignment = textAlignment
    }
    
    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont = (isFirstResponder || text!.isNotEmpty) ? UIFont.semibold(sz: 13.0) : UIFont.regular(sz: 16.0)
        return smallerFont
    }
    
    private var placeholderHeight: CGFloat {
        return placeholderInsets.y + placeholderFontFromFont(font!).lineHeight
    }
    
    // MARK: - Overrides
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if isFirstResponder || text!.isNotEmpty {
            return CGRect(x: placeholderInsets.x, y: placeholderInsets.y, width: bounds.width, height: placeholderHeight)
        } else {
            return textRect(forBounds: bounds)
        }
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    //Update My Kamal Mittal
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        if isFirstResponder || text!.isNotEmpty {
            return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y + placeholderHeight/2.5)
        } else {
            return bounds
        }
    }
}
