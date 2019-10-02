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
    var clearButtonClickEvent: (() -> Void)?
    
    internal var aspectConstraint: NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                postImageView.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                postImageView.addConstraint(aspectConstraint!)
            }
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
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
    
    func setup(imageAsset: Any) {
        
        postImageView.image = nil
        if let asset = imageAsset as? PHAsset {
            let imageSize = CGSize(
                width: asset.pixelWidth,
                height: asset.pixelHeight
//                width: screenWidth * UIScreen.main.scale,
//                height: screenWidth * UIScreen.main.scale
            )
           let requestOptions = PHImageRequestOptions()
            requestOptions.resizeMode = .exact
            requestOptions.isNetworkAccessAllowed = true
            
            PHCachingImageManager.default().requestImage(
                for: asset,
                targetSize: imageSize,
                contentMode: .aspectFill,
                options: requestOptions
            ) { [weak self] image, _ in
                guard let unself = self else { return }
                if let image = image {
                    unself.setCustomImage(image: image)
//                    unself.postImageView.image = image
                }
            }
        } else if let image = imageAsset as? UIImage {
            setCustomImage(image: image)
        }
    }
    func setCustomImage(image: UIImage) {
        
        let aspect = image.size.width / image.size.height
        
        let constraint = NSLayoutConstraint(item: postImageView!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: postImageView, attribute: NSLayoutConstraint.Attribute.height, multiplier: aspect, constant: 0.0)
        constraint.priority = UILayoutPriority(rawValue: 999)
        
        aspectConstraint = constraint
        
        postImageView.image = image
    }
    func setup(isCleareButtonHide: Bool) {
        cancelButton.isHidden = isCleareButtonHide
    }
    
    func set(url: URL?) {
        postImageView.sd_setImage(with: url, completed: nil)
    }
    
    @IBAction func clearButtonAction() {
        clearButtonClickEvent?()
    }
}
