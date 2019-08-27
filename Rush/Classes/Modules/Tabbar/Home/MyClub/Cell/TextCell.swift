//
//  TextCell.swift
//  Rush
//
//  Created by kamal on 16/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class TextCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.white
        clipsToBounds = true
        layer.cornerRadius = 8.0
    }
    
}

extension TextCell {
    func setup(text: String) {
        label.text = text
    }
}
