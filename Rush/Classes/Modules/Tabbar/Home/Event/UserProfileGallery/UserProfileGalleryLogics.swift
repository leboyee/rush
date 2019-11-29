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
        return list.count
    }
    
    func fillCell(_ cell: GalleryCell, _ indexPath: IndexPath) {
        let image = list[indexPath.row]
        let urlStr: String = image.main
        guard let url: URL = URL(string: urlStr) else { return }
        
       // Utils.showSpinner()
        SDWebImageManager.shared.imageLoader.requestImage(with: url, options: .continueInBackground, context: nil, progress: nil) { (image, _, _, _) in
            cell.imageView.image = image
            self.selectedImage = image
            //Utils.hideSpinner()
        }

    }
    
    // MARK: - Scroll To Item
    
    func scrollToItemIndex(_ flowLayout: UICollectionViewFlowLayout, _ index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.right, animated: false)
        }
        
    }
    
    // MARK: - Action Sheet
    func openShareSheet() {
        self.performSegue(withIdentifier: Segues.photoModelViewSegue, sender: self)
        return
        let buttons = ["Share", "Save"]
        Utils.alert(message: nil, title: nil, buttons: buttons, cancel: "Cancel", type: .actionSheet) { [weak self] (index) in
            guard let uwself = self else { return }
            if index == 0 {
                let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [uwself.selectedImage ?? UIImage()], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = uwself.view
                activityViewController.completionWithItemsHandler = { (type, completed, items, error) in
                    //uwself.dismissShareSheet()
                }
                uwself.present(activityViewController, animated: true)
            } else if index == 1 {
                if let image = uwself.selectedImage {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(uwself.image(_:didFinishSavingWithError:contextInfo:)), nil)
                } else {
                    let ac = UIAlertController(title: "Save error", message: "Failed to load image", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    uwself.present(ac, animated: true)
                    return
                }
                
            }
            
        }
    
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

extension UserProfileGalleryViewController: PhotoModelViewControllerDelegate {
    func delete(type: String, object: Any?) {
        //deletePhoto(id: "")
    }
    
    func savePhoto(_ object: Any?) {
        if let image = self.selectedImage {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: "Failed to load image", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
            return
        }
    }
}


extension UserProfileGalleryViewController {
     func deletePhoto(id: String) {
       Utils.showSpinner()
       ServiceManager.shared.deletePhoto(photoId: id) { [weak self] (status, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if status {
                unsafe.dismiss(animated: true, completion: nil)
            } else if let message = errorMsg {
                Utils.alert(message: message)
                
        }
        }
    }
    
}
