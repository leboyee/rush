//
//  ProfileTileViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

class ProfileTileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var noResultView: UIView!

    var imageList = [Any]()
    var picker = ImagePickerController()
    let layout = UICollectionViewFlowLayout()
    var selectedImage: UIImage? = UIImage(contentsOfFile: "")
    var imagedataList = [String: Any]()
    var imageArray = [Image]()
    let downloadQueue = DispatchQueue(label: "com.messapps.profileImages")
    let downloadGroup = DispatchGroup()
    var imagePageNo: Int = 1
    var imageNextPageExist = false
    var isFromOtherUserProfile = false
    var otherUserId = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack
        
        if isFromOtherUserProfile == false {
            let addImageButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 78, height: 36))
            addImageButton.setBackgroundImage(UIImage(named: "addImagesProfile"), for: .normal)
            //        addImageButton.setTitle("Add", for: .normal)
            //        addImageButton.setTitleColor(.white, for: .normal)
            addImageButton.addTarget(self, action: #selector(addImageButtonAction), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addImageButton)
        }
        noResultView.isHidden = true
        fetchImagesList()
        // Setup tableview
        setupCollectionView()
    }
      // MARK: - Actions
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImageButtonAction(_ sender: Any) {
        //Utils.notReadyAlert()
        photoLibraryPermissionCheck()
        
     }
 
    // MARK: - Setup Title
    func setTitle(titleStr: String) {
        titleLable.text = titleStr
    }
    
    func photoLibraryPermissionCheck() {
        Utils.authorizePhoto(completion: { [weak self] (status) in
            guard let unsafe = self else { return }
            if status == .alreadyAuthorized || status == .justAuthorized {
                DispatchQueue.main.async {
                    var parameters = Parameters()
                    parameters.allowedSelections = .limit(to: 5)
                    unsafe.picker = ImagePickerController(configuration: parameters)
                    unsafe.picker.delegate = self
                    unsafe.picker.navigationBar.isTranslucent = false
                    var assets = [PHAsset]()
                    for img in unsafe.imageList {
                        if let value = img as? PHAsset { assets.append(value) }
                    }
                    //unsafe.picker.
                    unsafe.picker.updateSelectedAssets(with: assets)
                    unsafe.present(unsafe.picker, animated: false, completion: nil)
                }
            } else {
                if status != .justDenied {
                    Utils.photoLibraryPermissionAlert()
                }
            }
        })
    }
}

// MARK: - Imagepicker fuctions
extension ProfileTileViewController: ImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: ImagePickerController, shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return true
    }
    
    func imagePickerController(_ picker: ImagePickerController, didFinishPickingImageAssets assets: [PHAsset]) {
        imageList = assets
        picker.dismiss(animated: false, completion: nil)
        DispatchQueue.main.async {
            self.getImagesDataList()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: ImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }

}
