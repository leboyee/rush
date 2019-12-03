//
//  UserProfileGalleryLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 04/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: - Handlers
extension UserProfileGalleryViewController {
    
    func cellHeight() -> CGSize {
        let size = CGSize(width: screenWidth, height: (collectionView.frame.size.height))
        return size
    }
    
    func cellCount() -> Int {
        return list.count
    }
    
    func fillCell(_ cell: GalleryCell, _ indexPath: IndexPath) {
        let image = list[indexPath.row]
        let urlStr: String = image.main
        
        if isFromChat && selectedImage != nil {
            cell.imageView.image = selectedImage
        } else {
            guard let url: URL = URL(string: urlStr) else { return }
            
            // Utils.showSpinner()
            SDWebImageManager.shared.imageLoader.requestImage(with: url, options: .continueInBackground, context: nil, progress: nil) { (image, _, _, _) in
                cell.imageView.image = image
                self.selectedImage = image
                //Utils.hideSpinner()
            }
        }
    }
    
    func willDisplay(_ indexPath: IndexPath) {
        if self.imageNextPageExist == true, self.list.count - 1 == indexPath.row {
            self.fetchImagesList()
        }
    }

    // MARK: - Scroll To Item
    func scrollToItemIndex(_ flowLayout: UICollectionViewFlowLayout, _ index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.right, animated: false)
        }
        
    }
    
    // MARK: - Action Sheet
    func openShareSheet() {
        self.performSegue(withIdentifier: Segues.photoModelViewSegue, sender: self)
        return
        let buttons = ["Share", "Save"]
        Utils.alert(message: nil, title: nil, buttons: buttons, cancel: "Cancel", type: .actionSheet) { [weak self] (index) in
            guard let uwself = self else { return }
            if index == 0 {
                let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [uwself.selectedImage ?? UIImage()], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = uwself.view
                activityViewController.completionWithItemsHandler = { (type, completed, items, error) in
                    //uwself.dismissShareSheet()
                }
                uwself.present(activityViewController, animated: true)
            } else if index == 1 {
                if let image = uwself.selectedImage {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(uwself.image(_:didFinishSavingWithError:contextInfo:)), nil)
                } else {
                    let ac = UIAlertController(title: "Save error", message: "Failed to load image", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    uwself.present(ac, animated: true)
                    return
                }
                
            }
            
        }
        
    }
    
    func dismissShareSheet() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Image Error Handling
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

extension UserProfileGalleryViewController: PhotoModelViewControllerDelegate {
    func delete(type: String, object: Any?) {
        var data = [Any]()
        if type == "share" && isFromOtherUserProfile {
            if isFromOtherUserProfile && selectedImage != nil, let img = selectedImage {
                data.append(img)
            } else if list.count > currentIndex {
                if let url = URL(string: list[currentIndex].main) {
                    do {
                        data.append(UIImage(data: try Data(contentsOf: url)) as Any)
                    } catch {}
                }
            }
            
            Utils.openActionSheet(controller: self, shareData: data)
        } else {
            let image = list[currentIndex]
            deletePhoto(id: image.id)
        }
    }
    
    func savePhoto(_ object: Any?) {
       Utils.authorizePhoto(completion: { [weak self] (status) in
                      guard let unsafe = self else { return }
                      if status == .alreadyAuthorized || status == .justAuthorized {
                               if let image = unsafe.selectedImage {
                                        UIImageWriteToSavedPhotosAlbum(image, self, #selector(unsafe.image(_:didFinishSavingWithError:contextInfo:)), nil)
                                    } else {
                                        let ac = UIAlertController(title: "Save error", message: "Failed to load image", preferredStyle: .alert)
                                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                                        unsafe.present(ac, animated: true)
                                        return
                                    }
                      } else {
                          if status != .justDenied {
                              Utils.photoLibraryPermissionAlert()
                          }
                      }
                  })
    }
}

extension UserProfileGalleryViewController {
    func deletePhoto(id: String) {
        Utils.showSpinner()
        ServiceManager.shared.deletePhoto(photoId: id) { [weak self] (status, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if status {
                unsafe.dismiss(animated: true, completion: nil)
            } else if let message = errorMsg {
                Utils.alert(message: message)
                
            }
        }
    }

    func fetchImagesList() {
          downloadQueue.async {
              let time = DispatchTime.now() + (2 * 60)
              _ = self.downloadGroup.wait(timeout: time)
              self.downloadGroup.enter()
            let params = [Keys.profileUserId: self.userId, Keys.pageNo: "\(self.imagePageNo)"]
              ServiceManager.shared.getImageList(params: params, closer: { [weak self] (data, _) in
                  guard let unsafe = self else { return }
                  if let list = data?[Keys.images] as? [[String: Any]] {
                      if list.isEmpty {
                          unsafe.imageNextPageExist = false
                          if unsafe.imagePageNo == 1 {
                              unsafe.list.removeAll()
                              unsafe.collectionView.reloadData()
                          }
                      } else {
                          var items = [Image]()
                          for item in list {
                              if let json = item["img_data"] as? String {
                                  let image = Image(json: json)
                                  image.id = "\(item["user_img_id"] ?? "")"
                                  image.isInstaImage = (item["insta_data"] as? String) == "" ? false : true
                                  items.append(image)
                              }
                          }
                          if unsafe.imagePageNo == 1 {
                              unsafe.list = items
                          } else {
                              unsafe.list.append(contentsOf: items)
                          }
                          unsafe.imagePageNo += 1
                          unsafe.imageNextPageExist = true
                          unsafe.collectionView.reloadData()
                      }
                  } else {
                      unsafe.collectionView.reloadData()
                  }
                  self?.downloadGroup.leave()
              })
          }
      }
}
