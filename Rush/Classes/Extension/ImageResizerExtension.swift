//
//  ImageResizer.swift
//  HalsaLife
//
//  Created by iChirag on 27/03/18.
//  Copyright © 2018 Messapps. All rights reserved.
//

import Foundation
import UIKit

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
        
        let imageRef = self.cgImage!.cropping(to: cropSquare);
        let newImage = UIImage(cgImage: imageRef!, scale: 1, orientation: self.imageOrientation)
        return newImage
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
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

    
}

