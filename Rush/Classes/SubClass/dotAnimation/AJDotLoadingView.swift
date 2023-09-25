//
//  WrapperView.swift
//  A_J_Dot_Loading_Indicator
//
//  Created by Nick Boyer on 24/01/20.
//  Copyright © 2020 Nick Boyer. All rights reserved.
//

import UIKit

public final class AJDotLoadingView: UIView {

    // MARK: - Public API

    @IBOutlet weak var dotLoadingIndicator: UIDotLoadingIndicator!

    public func startAnimating() {
        dotLoadingIndicator.startAnimating()
    }

    public func stopAnimating() {
        dotLoadingIndicator.stopAnimating()
        dotLoadingIndicator.removeFromSuperview()
    }
}

private var ajLoadingIndicatorAssociationKey = 0x1023

extension AJDotLoadingView: NibLoadable {}

public extension UIView {
    private var ajLoadingIndicator: AJDotLoadingView? {
        get {
            return objc_getAssociatedObject(self, &ajLoadingIndicatorAssociationKey) as? AJDotLoadingView
        }
        set {
            objc_setAssociatedObject(self, &ajLoadingIndicatorAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func ajShowDotLoadingIndicator() {
        let dotLoadView = AJDotLoadingView.createFromNib()
        dotLoadView.backgroundColor = .clear
        ajLoadingIndicator = dotLoadView
        
        safeAddSubView(subView: dotLoadView, viewTag: Int(ajLoadingIndicatorAssociationKey))
        
        dotLoadView.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: dotLoadView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: dotLoadView.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: dotLoadView.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: dotLoadView.rightAnchor).isActive = true

        ajLoadingIndicator?.startAnimating()
    }

    func ajHideDotLoadingIndicator() {
        ajLoadingIndicator?.stopAnimating()
        ajLoadingIndicator?.removeFromSuperview()
        ajLoadingIndicator = nil
    }
}
