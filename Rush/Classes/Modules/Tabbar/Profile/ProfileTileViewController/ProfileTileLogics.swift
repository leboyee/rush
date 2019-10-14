//
//  ProfileTileLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - Handlers
extension ProfileTileViewController {
    
   
    func cellHeight() -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = width/3
        return CGSize(width: cellWidth, height: cellWidth/0.6)
    }
    
    func cellCount() -> Int {
        return imageArray.count
    }
    
    func fillCell(_ cell:ProfileTileCell,_ indexPath:IndexPath){
        let urlStr : String = imageArray[indexPath.row]
        guard let url : URL = URL(string:urlStr) else { return }
        
        Utils.showSpinner()
        SDWebImageManager.shared.imageLoader.requestImage(with: url, options: .continueInBackground, context: nil, progress: nil) { (image, data, error, true) in
            cell.imageView.image=image
            self.selectedImage = image
            Utils.hideSpinner()
        }

    }
    
    // MARK: - Scroll To Item
    
    func scrollToItemIndex(_ flowLayout:UICollectionViewFlowLayout,_ index:Int)
    {
        let indexPath = IndexPath(row: index, section: 0)
       
        flowLayout.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    // MARK: - Action Sheet
    
    @objc func addButtonAction()
    {
        
    }

}
