//
//  ProfileImageCell.swift
//  Rush
//
//  Created by ideveloper on 31/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ProfileImageCell: UICollectionViewCell {

    @IBOutlet weak var userimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension ProfileImageCell {
    
    func set(url: URL?) {
        userimage.sd_setImage(with: url, placeholderImage: nil)
    }
}
