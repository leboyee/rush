//
//  ProfileTileLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import SDWebImage
import Photos

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
        let urlStr: String = imageArray[indexPath.row].thumb
        guard let url: URL = URL(string: urlStr) else { return }
        cell.imageView.sd_setImage(with: url) { (_, _, _, _) in
            
        }
        //Utils.showSpinner()
//        SDWebImageManager.shared.imageLoader.requestImage(with: url, options: .continueInBackground, context: nil, progress: nil) { (image, _, _, _) in
//            cell.imageView.image = image
//            self.selectedImage = image
//           // Utils.hideSpinner()
//        }

    }
    
    func willDisplay(_ indexPath: IndexPath) {
        if self.imageNextPageExist == true, self.imageArray.count - 1 == indexPath.row {
            self.fetchImagesList()
        }
        
    }
    
    @objc func addButtonAction() {
        
    }
    
    func getImagesDataList() {
        var counter = 0
        for image in imageList {
            if let value = image as? PHAsset {
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                manager.requestImageData(for: value, options: option) { [weak self] (data, _, _, _) in
                    guard let uwself = self else { return }
                    if let data = data {
                        if var img = UIImage(data: data) {
                            img = Utils.fixOrientation(img: img)
                            img = img.wxCompress()
                            let dataN = img.jpegData(compressionQuality: 1)
                            counter += 1
                            uwself.imagedataList["extra_image_\(counter)"] = dataN
                            if counter == uwself.imageList.count {
                                uwself.imagedataList["total_extra_images"] = "\(uwself.imageList.count)"
                                uwself.updateProfileAPI()
                            }
                        }
                    }
                }
            } else if let value = image as? UIImage {
                let data = value.jpegData(compressionQuality: 0.8)
                counter += 1
                imagedataList["extra_image_\(counter += 1)"] = data
                if counter == self.imageList.count {
                    self.imagedataList["total_extra_images"] = "\(self.imageList.count)"
                    self.updateProfileAPI()
                }
            }
        }
    }
}
// MARK: - API's
extension ProfileTileViewController {
    func fetchImagesList() {
        downloadQueue.async {
            let time = DispatchTime.now() + (2 * 60)
            _ = self.downloadGroup.wait(timeout: time)
            self.downloadGroup.enter()
            guard let userId = Authorization.shared.profile?.userId else { return }
            let params = [Keys.profileUserId: self.isFromOtherUserProfile ? self.otherUserId : userId, Keys.pageNo: "\(self.imagePageNo)"]
            ServiceManager.shared.getImageList(params: params, closer: { [weak self] (data, _) in
                guard let unsafe = self else { return }
                if let list = data?[Keys.images] as? [[String: Any]] {
                    if list.isEmpty {
                        unsafe.imageNextPageExist = false
                        if unsafe.imagePageNo == 1 {
                            unsafe.imageArray.removeAll()
                        }
                    } else {
                        var items = [Image]()
                        for item in list {
                            if let json = item["img_data"] as? String {
                                let image = Image(json: json)
                                items.append(image)
                            }
                        }
                        if unsafe.imagePageNo == 1 {
                            unsafe.imageArray = items
                        } else {
                            unsafe.imageArray.append(contentsOf: items)
                        }
                        unsafe.imagePageNo += 1
                        unsafe.imageNextPageExist = true
                        unsafe.collectionView.reloadData()
                    }
                }
                self?.noResultView.isHidden = self?.imageArray.count ?? 0 > 0 ? true : false
                self?.downloadGroup.leave()
            })
        }
    }
    
    func updateProfileAPI() {
        Utils.showSpinner()
        ServiceManager.shared.uploadUserProfileImage(params: imagedataList) { [weak self] (data, errorMessage) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if data != nil {
                unsafe.imagePageNo = 1
                unsafe.imagedataList.removeAll()
                unsafe.imageList.removeAll()
                unsafe.fetchImagesList()
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
