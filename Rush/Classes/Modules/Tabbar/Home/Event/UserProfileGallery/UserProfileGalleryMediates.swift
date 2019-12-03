//
//  UserProfileGalleryMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 04/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension UserProfileGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setupCollectionView() {
        collectionView.delegate=self
        collectionView.dataSource=self
        
        let nib = UINib(nibName: Cell.galleryCell, bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: Cell.galleryCell)
        
        collectionView.isPagingEnabled=true
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.galleryCell, for: indexPath) as? GalleryCell else { return UICollectionViewCell() }
        
        fillCell(cell, indexPath)
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplay(indexPath)
    }
    
    // MARK: - Scrollview Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(self.collectionView.contentOffset.x / self.collectionView.frame.size.width)
        let titleString = ("\((currentIndex+1)) of \(totalCount)")
        setTitle(titleStr: titleString)
        setupDateAndTimeOfPhoto(index: currentIndex)
    }
    
}

extension UserProfileGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellHeight()
    }
}
