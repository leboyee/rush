//
//  CreatePostLogics.swift
//  Rush
//
//  Created by ideveloper2 on 12/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

extension CreatePostViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension
        }
    }
    
    // Username cell (section 0)
    func userDetailCell(_ cell: UserNameTableViewCell) {
        if let club = clubInfo { // Club
            //cell.setup(title: club.user?.name ?? "")
            cell.setup(detail: "Posting in " + (club.clubName ?? ""))
            //cell.setup(url: club.user?.photo?.url())
        } else if let event = eventInfo { // Event
            //cell.setup(title: event.creator?.name ?? "")
            cell.setup(detail: "Posting in " + (event.title))
            //cell.setup(url: event.creator?.photo?.url())
        } else if let subclass = subclassInfo { // Subclass
            //cell.setup(title: Authorization.shared.profile?.name ?? "")
            cell.setup(detail: "Posting in " + (subclass.name))
            //cell.setup(url: Authorization.shared.profile?.photo?.url())
        }
        cell.setup(title: Authorization.shared.profile?.name ?? "")
        cell.setup(url: Authorization.shared.profile?.photo?.url())
    }
    
    // Textview cell (section 1)
    func fillTextViewCell(_ cell: UserPostTextTableViewCell) {
        
        cell.updateTableView = {
            [weak self] (textView) in
            guard let unself = self else { return }
            
            unself.postText = textView.text.trimmingCharacters(in: .whitespaces)
            unself.createButtonValidation()
            
            let startHeight = textView.frame.size.height
            var calcHeight = textView.sizeThatFits(textView.frame.size).height
            if calcHeight == startHeight && textView.text.isEmpty {
                calcHeight += 1
            }
            
            let numLines = Int((Float(textView.contentSize.height / (textView.font?.lineHeight ?? 0))))
            
            if unself.bigFontCount != 0 && unself.bigFontCount <= textView.text.count {
                cell.setup(font: UIFont.regular(sz: 17))
            } else {
                if numLines >= 3 {
                    unself.bigFontCount = textView.text.count
                    cell.setup(font: UIFont.regular(sz: 17))
                } else {
                    cell.setup(font: UIFont.displayBold(sz: 28))
                }
            }
            
            if startHeight != calcHeight {
                // Disable animations
                UIView.setAnimationsEnabled(false)
                unself.tableView.beginUpdates()
                unself.tableView.endUpdates()
                // Enable animations
                UIView.setAnimationsEnabled(true)
            }
        }
        
        cell.textDidEndEditing = {
            [weak self] () in
            guard let unself = self else { return }
            unself.createButtonValidation()
        }
    }
    
    // Image cell (section 2)
    func fillImageCell(_ cell: UserPostImageTableViewCell, _ indexPath: IndexPath) {
        let asset = imageList[indexPath.row]
        cell.setup(imageAsset: asset)
        
        cell.clearButtonClickEvent = { [weak self] () in
            guard let unself = self else { return }
            unself.imageList.remove(at: indexPath.row)
            unself.tableView.reloadData()
        }
    }
}

// MARK: - Services
extension CreatePostViewController {
    
    func createPostAPI() {
        if let club = clubInfo {
            imagedataList[Keys.desc] = postText
            imagedataList[Keys.dataId] = club.id
            imagedataList[Keys.dataType] = Text.club
        } else if let event = eventInfo {
            imagedataList[Keys.desc] = postText
            imagedataList[Keys.dataId] = event.id
            imagedataList[Keys.dataType] = Text.event
        } else if let subclass = subclassInfo {
            imagedataList[Keys.desc] = postText
            imagedataList[Keys.dataId] = subclass.classId
            imagedataList[Keys.dataType] = Text.classKey
        } else {
            
        }
        imagedataList[Keys.totalPhotos] = imageList.count
        Utils.showSpinner()
        
        ServiceManager.shared.createPost(params: imagedataList) { [weak self] (data, errorMessage) in
            guard let uwself = self else { return }
            Utils.hideSpinner()
            
            if let value = data?[Keys.post] as? [String: Any] {
                do {
                    let dataClub = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let decoder = JSONDecoder()
                    let value = try decoder.decode(Post.self, from: dataClub)
                    DispatchQueue.main.async {
                        uwself.delegate?.createPostSuccess(value)
                    }
                    uwself.close()
                } catch {
                    
                }
            } else {
                Utils.alert(message: errorMessage ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func getImagesDataList(index: Int) {
        
        if index < imageList.count {
            let image = imageList[index]
            if let value = image as? PHAsset {
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                manager.requestImageData(for: value, options: option) { [weak self] (data, _, _, _) in
                    guard let uwself = self else { return }
                    if let data = data {
                        if var img = UIImage(data: data) {
                            img = Utils.fixOrientation(img: img)
                            img = img.wxCompress()
                            let dataN = img.jpegData(compressionQuality: 0.8)
                            uwself.imagedataList["photo_\(index + 1)"] = dataN
                            uwself.getImagesDataList(index: index + 1)
                        }
                    }
                }
            } else if let value = image as? UIImage {
                let data = value.jpegData(compressionQuality: 0.8)
                imagedataList["photo_\(index + 1)"] = data
                getImagesDataList(index: index + 1)
            }
        } else {
            createPostAPI()
        }
    }
}
