//
//  UIViewHelper.swift
//  A_J_Dot_Loading_Indicator
//
//  Created by Nick Boyer on 24/01/20.
//  Copyright © 2020 Nick Boyer. All rights reserved.
//

import UIKit

// MARK: - Safe Add SubView

public extension UIView {
    func safeAddSubView(subView: UIView, viewTag: Int = 1000000) {
        guard tag != viewTag else { return }

        let addedView = subviews.compactMap { $0.viewWithTag(viewTag) }.first

        if let saddedView = addedView {
            saddedView.removeFromSuperview()
        }

        subView.tag = viewTag
        addSubview(subView)
    }
}

// MARK: - Nib Loadable

public protocol NibLoadable: class {
    static var nibName: String { get }
    static var bundle: Bundle? { get }
}

public extension NibLoadable {
    static var bundle: Bundle? {
        return Bundle(for: Self.self)
    }

    static var nibName: String {
        return String(describing: Self.self)
    }

    static var nib: UINib {
        return UINib(nibName: nibName, bundle: bundle)
    }
}

public extension NibLoadable where Self: UIView {
    static func createFromNib(_ owner: AnyObject? = nil) -> Self {
        return (nib.instantiate(withOwner: owner, options: nil).first as? Self)!
    }
}
