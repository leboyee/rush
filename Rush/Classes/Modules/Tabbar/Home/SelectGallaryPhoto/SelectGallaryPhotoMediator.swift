//
//  ContributeMediator.swift
//  Rush
//
//  Created by iChirag on 20/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//

import UIKit
import Photos

extension SelectGallaryPhotoViewController {
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: Cell.selectGallaryPhoto, bundle: nil), forCellReuseIdentifier: Cell.selectGallaryPhoto)
        tableView.reloadData()
        
        (PHCachingImageManager.default() as? PHCachingImageManager)?.allowsCachingHighQualityImages = false
    }
    
    func reload() {
        tableView.reloadData()
    }
}

extension SelectGallaryPhotoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.selectGallaryPhoto) as? SelectGallaryPhotoCell else { return UITableViewCell() }
        fillCell(cell, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let albumPhoto = source[indexPath.section][indexPath.row]
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        let fetchResult = PHAsset.fetchAssets(in: albumPhoto, options: options)
        
        if fetchResult.count > 0 {
            return UITableView.automaticDimension
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
}
