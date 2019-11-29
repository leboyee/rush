//
//  ProfileTileMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ProfileTileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
     func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: Cell.profileTileCell, bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: Cell.profileTileCell)
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.profileTileCell, for: indexPath) as? ProfileTileCell else { return UICollectionViewCell() }
        fillCell(cell, indexPath)
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplay(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "UserProfileGalleryViewController") as? UserProfileGalleryViewController else { return }
//        vc.list = self.imageArray
//        vc.user = Authrosiz
//        vc.currentIndex = index
//        vc.isFromOtherUserProfile = false
//        self.navigationController?.pushViewController(universityViewController, animated: false)
        
    }
        
}

extension ProfileTileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellHeight()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
