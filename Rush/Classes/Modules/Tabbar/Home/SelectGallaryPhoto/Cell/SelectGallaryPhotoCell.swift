//
//  ContributeContactCell.swift
//  GotFriends
//
//  Created by iChirag on 16/01/19.
//  Copyright © 2019 Kamal Mittal. All rights reserved.
//

import UIKit
import Photos

class SelectGallaryPhotoCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var checkmarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

// MARK: - Others
extension SelectGallaryPhotoCell {
    
    func setup(album: PHAssetCollection) {
        userImageView.image = nil
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        let fetchResult = PHAsset.fetchAssets(in: album, options: options)
        
        if fetchResult.count > 0 {
            if let asset = fetchResult.lastObject {
                
                let imageSize = CGSize(
                    width: frame.height * UIScreen.main.scale,
                    height: frame.height * UIScreen.main.scale
                )
                
                let requestOptions = PHImageRequestOptions()
                requestOptions.resizeMode = .exact
                requestOptions.isNetworkAccessAllowed = true
                
                userImageView.image = nil
                PHCachingImageManager.default().requestImage(
                    for: asset,
                    targetSize: imageSize,
                    contentMode: .aspectFill,
                    options: requestOptions
                ) { [weak self] image, _ in
                    guard let self_ = self else { return }
                    if let image = image {
                        self_.userImageView.image = image
                    }
                }
            }
        }
        
        userName.text = album.localizedTitle ?? "Others"
        
        /*
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        let fetchResult = PHAsset.fetchAssets(in: album, options: options)
        let imageSize = CGSize(
            width: frame.height * UIScreen.main.scale,
            height: frame.height * UIScreen.main.scale
        )
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = .exact
        requestOptions.isNetworkAccessAllowed = true
        
        userName.text = album.localizedTitle ?? "Others"
        
        
        fetchResult.enumerateObjects({ asset, index, stop in
            if index > 2 {
                stop.initialize(to: true)
                return
            }
            
            PHCachingImageManager.default().requestImage(
                for: asset,
                targetSize: imageSize,
                contentMode: .aspectFill,
                options: requestOptions
            ) { [weak self] image, _ in
                if let image = image {
                    self?.userImageView.image = image
                }
            }
        })
        */
    }
    
    func setup(isCheckMark: Bool) {
        checkmarkButton.isSelected = isCheckMark
    }
}

// MARK: - Actions
extension SelectGallaryPhotoCell {
    
}
