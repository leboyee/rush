//
//  UserPostImageTableViewCell.swift
//  Rush
//
//  Created by ideveloper2 on 12/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

class UserPostImageTableViewCell: UITableViewCell {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cancelButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = cancelButton.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Other function
extension UserPostImageTableViewCell {
    
    func setup(imageAsset: PHAsset) {
        
        let imageSize = CGSize(
            width: screenWidth * UIScreen.main.scale,
            height: screenWidth * UIScreen.main.scale
        )
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = .exact
        requestOptions.isNetworkAccessAllowed = true
        
        PHCachingImageManager.default().requestImage(
            for: imageAsset,
            targetSize: imageSize,
            contentMode: .aspectFill,
            options: requestOptions
        ) { [weak self] image, _ in
            guard let self_ = self else { return }
            if let image = image {
                self_.postImageView.image = image
            }
        }
    }
}
