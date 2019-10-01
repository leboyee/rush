//
//  SortingCell.swift
//  Rush
//
//  Created by ideveloper on 10/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class SortingCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

// MARK: - Other functions
extension SortingCell {
    
    func setup(text: String) {
        textLabel.text = text
    }
    
    func setup(image: UIImage) {
        arrowImageView.image = image
    }

}
