//
//  ContributePresenter.swift
//  GotFriends
//
//  Created by iChirag on 16/01/19.
//  Copyright © 2019 Kamal Mittal. All rights reserved.
//

import UIKit

extension SelectGallaryPhotoViewController {
    
    func fillCell(_ cell: SelectGallaryPhotoCell, _ indexPath: IndexPath) {
        
        let albumPhoto = source[indexPath.section][indexPath.row]
        cell.setup(album: albumPhoto)
        
        if selectedTitle == albumPhoto.localizedTitle ?? "Others" {
            selectedIndex = indexPath.section
            cell.setup(isCheckMark: true)
        } else {
            cell.setup(isCheckMark: false)
        }
    }
    
    func selectCell(_ indexPath: IndexPath) {
        let albumPhoto = source[indexPath.section][indexPath.row]
        selectedTitle = albumPhoto.localizedTitle ?? "Others"
        selectedAlbum = source[indexPath.section][indexPath.row]
        tableView.reloadData()
    }
}
