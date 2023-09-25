//
//  RRedArrowImageView.swift
//  Rush
//
//  Created by Nick Boyer on 24/01/20.
//  Copyright © 2020 Nick Boyer. All rights reserved.
//

import UIKit

class RRedArrowImageView: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCustomUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupCustomUI() {
       image = #imageLiteral(resourceName: "red-arrow.pdf")
       highlightedImage = UIImage(named: "white-arrow")
    }
}
