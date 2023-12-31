//
//  PostImagesCell.swift
//  Rush
//
//  Created by kamal on 11/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class PostImagesCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    var list: [Image]?
    let padding: CGFloat = 1.0
    var showImages: ((_ index: Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

// MARK: - Setup Functions
extension PostImagesCell {
    
    private func setup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: Cell.postImage, bundle: nil), forCellWithReuseIdentifier: Cell.postImage)
    }
}

extension PostImagesCell {
    func set(images: [Image]?) {
        self.list = images
        collectionView.reloadData()
    }
}

// MARK: - Delegates
extension PostImagesCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 {
            showImages?(0)
        } else {
            showImages?(indexPath.row)
        }
    }
}

extension PostImagesCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsCount = list?.count ?? 0
        var count = itemsCount % 2 == 0 ? itemsCount : itemsCount - 1
        if itemsCount == 1 {
            count = 1
        } else if itemsCount >= 6 {
            count = 6
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.postImage, for: indexPath) as? PostImageCell {
            let totol = collectionView.numberOfItems(inSection: indexPath.section)

            if let image = list?[indexPath.row] {
                if totol == 1 {
                   cell.set(url: image.url()) // Show main or original image
                } else {
                    cell.set(url: image.urlLarge()) // Show large image to save memory
                }
            }
            
            // count label hide if any one condition true
            // 1. total items and cell count are same (also true for total = 1)
            // 2. index item is less than total items
            if indexPath.row < totol - 1 || totol == list?.count ?? 0 {
                cell.countLabel.isHidden = true
                cell.set(isHideOverlay: true)
            } else {
                cell.countLabel.isHidden = false
                let count = (list?.count ?? 0) - indexPath.row
                cell.countLabel.text = "+\(count)"
                cell.set(isHideOverlay: false)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

extension PostImagesCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = list?.count ?? 0
        if count == 1 {
            return CGSize(width: screenWidth, height: screenWidth)
        } else {
            let width = (screenWidth - padding)/2.0
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
}
