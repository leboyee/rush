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
        let cellWidth = (width - 3) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func cellCount() -> Int {
        return imageArray.count
    }
    
    func fillCell(_ cell: ProfileTileCell, _ indexPath: IndexPath) {
        let urlStr: String = imageArray[indexPath.row]
        guard let url: URL = URL(string: urlStr) else { return }
        
        Utils.showSpinner()
        SDWebImageManager.shared.imageLoader.requestImage(with: url, options: .continueInBackground, context: nil, progress: nil) { (image, _, _, _) in
            cell.imageView.image = image
            self.selectedImage = image
            Utils.hideSpinner()
        }

    }
    // MARK: - Action Sheet
    
    @objc func addButtonAction() {
        
    }

}
