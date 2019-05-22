//
//  CustomImagePageControl.swift
//  ReportCutter
//
//  Created by Suresh Jagnani on 26/03/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//

import UIKit

class CustomImagePageControl: UIPageControl {
    
      //  @IBInspectable var currentPageImage: UIImage?
        
      //  @IBInspectable var otherPagesImage: UIImage?
    var dotSize = 8;
    var dotSpacing = 5;

    var currentPageImage:UIImage = UIImage(named: "activePageController")!
    var otherPagesImage:UIImage = UIImage(named: "pagDot")!
    

        override var numberOfPages: Int {
            didSet {
                layoutSubviews()
            }
        }
        
        override var currentPage: Int {
            didSet {
                updateDots()
                layoutSubviews()
            }
        }
        
        override func awakeFromNib() {
            super.awakeFromNib()
            pageIndicatorTintColor = UIColor.pageControllerDot
            currentPageIndicatorTintColor = .white
            clipsToBounds = false
        }
    
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
        }
        
        private func updateDots() {
        
            
        }
}
