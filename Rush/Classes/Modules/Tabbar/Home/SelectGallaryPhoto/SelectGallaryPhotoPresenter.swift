//
//  ContributePresenter.swift
//  GotFriends
//
//  Created by iChirag on 16/01/19.
//  Copyright © 2019 Kamal Mittal. All rights reserved.
//


import UIKit

extension SelectGallaryPhotoViewController {
    
    func fillCell(_ cell: SelectGallaryPhotoCell,_ indexPath: IndexPath) {
        cell.setup(album: source[indexPath.section][indexPath.row])
        
        if selectedIndex == indexPath.section {
            cell.setup(isCheckMark: true)
        } else {
            cell.setup(isCheckMark: false)
        }
    }
    
    func selectCell(_ indexPath: IndexPath) {
        selectedIndex = indexPath.section
        selectedAlbum = source[indexPath.section][indexPath.row]
        tableView.reloadData()
    }
}
