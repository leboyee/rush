//
//  TextCell.swift
//  Rush
//
//  Created by kamal on 16/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class TextCell: UICollectionViewCell {

    @IBOutlet weak var label: CustomBlackLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //backgroundColor = isDarkModeOn ? UIColor.separatorColorDark : UIColor.white
        //label.textColor = isDarkModeOn ? UIColor.white : UIColor.bgBlack
        clipsToBounds = true
        layer.cornerRadius = 8.0
    }

}

extension TextCell {
    
    func setup(text: String) {
        label.text = text
    }
    
}

