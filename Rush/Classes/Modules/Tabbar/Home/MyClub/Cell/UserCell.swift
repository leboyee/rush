//
//  UserCell.swift
//  Rush
//
//  Created by ideveloper on 31/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

//MARK: - Others
extension UserCell {
    
    func setup(text: String) {
        titleLabel.textColor = text == Text.viewAll ? UIColor.lightGrayColor : UIColor.bgBlack
        titleLabel.text = text
    }
    
    func setup(image: String) {
        if image == Text.viewAll {
            imageView.image = nil
        } else {
            
        }
    }
}
