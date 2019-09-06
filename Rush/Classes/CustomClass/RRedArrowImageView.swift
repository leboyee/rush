//
//  RRedArrowImageView.swift
//  Rush
//
//  Created by kamal on 06/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
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
