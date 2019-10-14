//
//  UserProfileGalleryLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 04/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - Handlers
extension UserProfileGalleryViewController {
  
    func cellHeight() -> CGSize {
        let size = CGSize(width: screenWidth, height: (collectionView.frame.size.height))
        return size
    }
    
    func cellCount() -> Int {
        return imageArray.count
    }
    
    func fillCell(_ cell: GalleryCell, _ indexPath: IndexPath) {
        let urlStr: String = imageArray[indexPath.row]
        guard let url: URL = URL(string: urlStr) else { return }
        
        Utils.showSpinner()
        SDWebImageManager.shared.imageLoader.requestImage(with: url, options: .continueInBackground, context: nil, progress: nil) { (image, data, error, true) in
            cell.imageView.image=image
            self.selectedImage = image
            Utils.hideSpinner()
        }

    }
    
    // MARK: - Scroll To Item
    
    func scrollToItemIndex(_ flowLayout: UICollectionViewFlowLayout, _ index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        flowLayout.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    // MARK: - Action Sheet
    func openShareSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)

        let shareAction = UIAlertAction(title: "Share", style: .default, handler: {(alert: UIAlertAction!) in print("share")
            self.dismissShareSheet()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")
            self.dismissShareSheet()
        })

        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(alert: UIAlertAction!) in
            if let image = self.selectedImage {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            } else {
                let ac = UIAlertController(title: "Save error", message: "Failed to load image", preferredStyle: .alert)
                          ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
                return
            }
            
        })
        alertController.addAction(shareAction)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: {})
    }
        
    func dismissShareSheet() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Image Error Handling
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
           if let error = error {
               // we got back an error!
               let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
               ac.addAction(UIAlertAction(title: "OK", style: .default))
               present(ac, animated: true)
           } else {
               let ac = UIAlertController(title: "Saved!", message: "Image has been saved to your photos.", preferredStyle: .alert)
               ac.addAction(UIAlertAction(title: "OK", style: .default))
               present(ac, animated: true)
           }
       }
}
