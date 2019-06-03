//
//  PhotoTableViewCellMediator.swift
//  AutoBuyer
//
//  Created by ideveloper on 23/01/18.
//  Copyright © 2018 Messapps. All rights reserved.
//

import UIKit

extension EventTypeCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    //MARK: - Presenter Functions
    func reload() {
        collectionView?.reloadData()
    }
    
    //MARK: - Collection View Delegate and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cellType == .event {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.event, for: indexPath) as! EventCell
            fillEventCell(cell, indexPath)
            return cell
        } else if cellType == .clubUser {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.user, for: indexPath) as! UserCell
            fillUserCell(cell, indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.profileImage, for: indexPath) as! ProfileImageCell
            fillImagesCell(cell, indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellSelectedEvent(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 8)
    }
}
