//
//  ImageResizer.swift
//  HalsaLife
//
//  Created by iChirag on 27/03/18.
//  Copyright © 2018 Messapps. All rights reserved.
//

import Foundation
import UIKit

public enum CompressType {
    case session
    case timeline
}

extension UIImage {
    
    /**
     That function is basically used for get Square Image
     for image which call.
     */
    func squareImage() -> UIImage? {
        
        let originalWidth  = self.size.width
        let originalHeight = self.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        let posX = round((originalWidth  - edge) / 2.0)
        let posY = round((originalHeight - edge) / 2.0)
        
        let cropSquare = CGRect(x: posX, y: posY, width: edge, height: edge)
        
        let imageRef = self.cgImage!.cropping(to: cropSquare)
        let newImage = UIImage(cgImage: imageRef!, scale: 1, orientation: self.imageOrientation)
        return newImage
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        //UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.mainScreen().scale)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
     func image(withBase64  base64: String) -> UIImage? {
        guard let dataDecoded = Data(base64Encoded: base64, options: .ignoreUnknownCharacters),
            let decodedImage = UIImage(data: dataDecoded) else {
                return nil
        }
        return decodedImage
    }
    
    //only by width
    func resizedImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func roundedImageWithBorder(width: CGFloat, borderWidth: CGFloat, color: UIColor) -> UIImage? {
        let square = CGSize(width: width, height: width)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = borderWidth
        imageView.layer.borderColor = color.cgColor
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

// MARK: - Compress size without lossing quality

public extension UIImage {
    
    /**
     chat image compress
     
     - parameter type: session image boundary is 800, timeline is 1280
     
     - returns: thumb image
     */
    func wxCompress(type: CompressType = .timeline) -> UIImage {
        let size = self.wxImageSize(type: type)
        let reImage = resizedImage(size: size)
        return reImage
    }
    
    /**
     get compress image size
     
     - parameter type: session  / timeline
     
     - returns: size
     */
    private func wxImageSize(type: CompressType) -> CGSize {
        var width = self.size.width
        var height = self.size.height
        
        var boundary: CGFloat = 1280
        
        // width, height <= 1280, Size remains the same
        guard width > boundary || height > boundary else {
            return CGSize(width: width, height: height)
        }
        
        // aspect ratio
        let s = max(width, height) / min(width, height)
        if s <= 2 {
            // Set the larger value to the boundary, the smaller the value of the compression
            let x = max(width, height) / boundary
            if width > height {
                width = boundary
                height /= x
            } else {
                height = boundary
                width /= x
            }
        } else {
            // width, height > 1280
            if min(width, height) >= boundary {
                boundary = type == .session ? 800 : 1280
                // Set the smaller value to the boundary, and the larger value is compressed
                let x = min(width, height) / boundary
                if width < height {
                    width = boundary
                    height /= x
                } else {
                    height = boundary
                    width /= x
                }
            }
        }
        return CGSize(width: width, height: height)
    }
    
    /**
     Zoom the picture to the specified size
     
     - parameter newSize: image size
     
     - returns: new image
     */
    private func resizedImage(size: CGSize) -> UIImage {
        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        var newImage: UIImage!
        UIGraphicsBeginImageContext(newRect.size)
        newImage = UIImage(cgImage: self.cgImage!, scale: 1, orientation: self.imageOrientation)
        newImage.draw(in: newRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
