//
//  InputSource.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 14.01.16.
//
//

import UIKit

/// A protocol that can be adapted by different Input Source providers
@objc public protocol InputSource {
    /**
     Load image from the source to image view.
     - parameter imageView: Image view to load the image into.
     - parameter callback: Callback called after image was set to the image view.
     - parameter image: Image that was set to the image view.
     */
    func load(to imageView: UIImageView, with callback: @escaping (_ image: UIImage?) -> Void)
    
    /**
     Cancel image load on the image view
     - parameter imageView: Image view that is loading the image
     */
    @objc optional func cancelLoad(on imageView: UIImageView)
}

/// Input Source to load plain UIImage
@objcMembers
open class ImageSource: NSObject, InputSource {
    var image: UIImage!
    var imageUrl: URL!
    
    /// Initializes a new Image Source with UIImage
    /// - parameter image: Image to be loaded
    public init(image: UIImage) {
        self.image = image
    }
    
    /// Initializes a new Image Source with an image name from the main bundle
    /// - parameter imageString: name of the file in the application's main bundle
    public init?(imageString: String) {
        if let image = UIImage(named: imageString) {
            self.image = image
            super.init()
        } else {
            return nil
        }
    }
    public init?(url: String) {
        if let url = URL(string: url) {
            imageUrl = url
            super.init()
        } else {
            return nil
        }
    }
    
    public func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {
        if image == nil {
            imageView.sd_setImage(with: imageUrl) { (image, _, _, _) in
                callback(image)
            }
        } else {
            imageView.image = image
            callback(image)
        }
        
    }
}
