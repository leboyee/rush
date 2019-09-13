//
//  PostImageCell.swift
//  Rush
//
//  Created by kamal on 12/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class PostImageCell: UICollectionViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension PostImageCell {
    func set(url: URL?) {
        postImageView.sd_setImage(with: url, placeholderImage: nil)
    }
}
