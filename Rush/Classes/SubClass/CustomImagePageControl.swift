//
//  CustomImagePageControl.swift
//  ReportCutter
//
//  Created by Suresh Jagnani on 26/03/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//

import UIKit

class CustomImagePageControl: UIPageControl {
            
    var dotSize = 8
    var dotSpacing = 5
    var isSteps: Bool = false
    var currentPageImage = UIImage(named: "activePageController")!
    var otherPagesImage = UIImage(named: "pagDot")!
    var anotherPagesImage = UIImage(named: "pagDot-done")!
    
        override var numberOfPages: Int {
            didSet {
                layoutSubviews()
                if isSteps == true {
                    updateDots()
                }
            }
        }
        
        override var currentPage: Int {
            didSet {
                layoutSubviews()
                if isSteps == true {
                    updateDots()
                }
            }
        }
        
        override func awakeFromNib() {
            super.awakeFromNib()
            pageIndicatorTintColor = UIColor.pageControllerDot
            currentPageIndicatorTintColor = .white
            clipsToBounds = false
        }
    /*
        override func layoutSubviews() {
            var i = 0
            let width = self.dotSize * (self.subviews.count + 3) +  (self.dotSpacing * (Int(self.subviews.count - 1)))
            
            var x = ((self.frame.size.width / 2) - (CGFloat(width / 2)))
            let y = ((self.frame.size.height / 2) - (CGFloat(self.dotSize / 2)))
            
            for (index, subview) in subviews.enumerated() {
                var frame = subview.frame
                frame.origin.x = x
                frame.origin.y = y
                if currentPage == index {
                    frame.size = CGSize(width: self.dotSize * 6, height: self.dotSize)
                    x += CGFloat(((self.dotSize * 6) + (self.dotSpacing)))
                }
                else {
                    frame.size = CGSize(width: self.dotSize, height: self.dotSize)
                    x += CGFloat(((self.dotSize) + (self.dotSpacing)))
                    
                }
                subview.layer.cornerRadius = CGFloat(self.dotSize / 2)
                subview.frame = frame;
                i += 1
            }
        }*/
    
    override func layoutSubviews() {
        var i = 0
        let width = self.dotSize * (self.subviews.count + 3) +  (self.dotSpacing * (Int(self.subviews.count - 1)))
        
        var x = ((self.frame.size.width / 2) - (CGFloat(width / 2)))
        let y = ((self.frame.size.height / 2) - (CGFloat(self.dotSize / 2)))
        
        for (index, subview) in subviews.enumerated() {
            var frame = subview.frame
            frame.origin.x = x
            frame.origin.y = y
            if currentPage == index {
                frame.size = CGSize(width: self.dotSize * 6, height: self.dotSize)
                x += CGFloat(((self.dotSize * 6) + (self.dotSpacing)))
            } else {
                frame.size = CGSize(width: self.dotSize, height: self.dotSize)
                x += CGFloat(((self.dotSize) + (self.dotSpacing)))
                
            }
            subview.layer.cornerRadius = CGFloat(self.dotSize / 2)
            subview.frame = frame
            i += 1
        }
    }

    func updateDots() {
        var i = 0
        for view in self.subviews {
            let scale: CGFloat = 1.0
            view.transform = CGAffineTransform.init(scaleX: 1/scale, y: 1/scale)
            if let imageView = self.imageForSubview(view) {
                if i == self.currentPage {
                    imageView.image = self.currentPageImage
                } else if self.currentPage > i {
                    imageView.image = self.anotherPagesImage
                } else {
                    imageView.image = self.otherPagesImage
                }
                i += 1
            } else {
                var dotImage = self.otherPagesImage
                if i == self.currentPage {
                    dotImage = self.currentPageImage
                } else if self.currentPage > i {
                    dotImage = self.anotherPagesImage
                }
                view.clipsToBounds = false
                view.addSubview(UIImageView(image: dotImage))
                i += 1
            }
        }
    }
    
    fileprivate func imageForSubview(_ view: UIView) -> UIImageView? {
        var dot: UIImageView?
        
        if let dotImageView = view as? UIImageView {
            dot = dotImageView
        } else {
            for foundView in view.subviews {
                if let imageView = foundView as? UIImageView {
                    dot = imageView
                    break
                }
            }
        }
        
        return dot
    }
}
