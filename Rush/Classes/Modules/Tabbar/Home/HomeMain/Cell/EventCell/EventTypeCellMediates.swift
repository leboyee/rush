//
//  PhotoTableViewCellMediator.swift
//  AutoBuyer
//
//  Created by ideveloper on 23/01/18.
//  Copyright © 2018 Messapps. All rights reserved.
//

import UIKit

extension EventTypeCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - Presenter Functions
    func reload() {
        collectionView?.reloadData()
    }
    
    // MARK: - Collection View Delegate and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cellType == .interests {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.text, for: indexPath) as? TextCell else { return UICollectionViewCell() }
            fillInterestCell(cell, indexPath)
            return cell
        } else if cellType == .event {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.event, for: indexPath) as? EventCell else { return UICollectionViewCell() }
            fillEventCell(cell, indexPath)
            return cell
        } else if cellType == .invitees || cellType == .friends {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.user, for: indexPath) as? UserCell else { return UICollectionViewCell() }
            if cellType == .invitees {
                fillUserCell(cell, indexPath)
            } else if cellType == .friends {
                fillFriendCell(cell, indexPath)
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.profileImage, for: indexPath) as? ProfileImageCell else { return UICollectionViewCell() }
            fillImagesCell(cell, indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellSelectedEvent(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if cellType == .interests {
            return UIEdgeInsets(top: 0, left: 24, bottom: 16, right: 8)
        } else if cellType == .friends || cellType == .invitees {
            return UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
        }
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cellWillDisplay?(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if cellType == .profileImage {
           return 2.0
        }
        return 8.0
    }
}
