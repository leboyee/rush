//
//  EditProfileViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 04/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos
import DKImagePickerController
import DKPhotoGallery
import DKCamera

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var photoImage: UIImage?
    var selectedGender: Int = 0
    var selectedRelation: Int = 0
    var selectedDate = Date().minus(years: 19)
    var selectedIndex = -1
    var dob = ""
    var gender = ""
    var relation = ""
    var homeTown = ""
    var address = ""
    var profile = Authorization.shared.profile
    var updateImage = false
    var majorArray = [String]()
    var minorArray = [String]()
    var interest = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        profile = Authorization.shared.profile
        tabBarController?.tabBar.isHidden = false
        title = ""
        tableView.reloadData()
    }
}
// MARK: - Setup
extension EditProfileViewController {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
        let majArray = profile?.majors ?? [Major]()
        let minArray = profile?.minors ?? [Minor]()
        majorArray = majArray.map({($0.majorName ?? "")})
        minorArray = minArray.map({($0.minorName ?? "")})
        setupTableView()
        setupNavigation()
        
    }
}

// MARK: - Other Functions
extension EditProfileViewController {
    
    func setupNavigation() {
        self.view.backgroundColor = UIColor.bgBlack
        
        let rightBar =  UIBarButtonItem(title: "⚙︎", style: .plain, target: self, action: #selector(settingButtonAction))
        navigationItem.rightBarButtonItem = rightBar
        
        let leftBar = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        navigationItem.leftBarButtonItem = leftBar
    }
    
}

// MARK: - Actions
extension EditProfileViewController {
    @objc func settingButtonAction() {
        performSegue(withIdentifier: Segues.settingViewControllerSegue, sender: nil)
    }
    
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Image Picker
extension EditProfileViewController {
    
    func photoLibraryPermissionCheck() {
        Utils.authorizePhoto(completion: { [weak self] (status) in
            guard let unsafe = self else { return }
            if status == .alreadyAuthorized || status == .justAuthorized {
                    unsafe.cameraPermissionCheck()
            } else {
                if status != .justDenied {
                    Utils.photoLibraryPermissionAlert()
                }
            }
        })
    }
    
    func cameraPermissionCheck() {
        Utils.authorizeVideo(completion: { [weak self] (status) in
            guard let unsafe = self else { return }
            if status == .alreadyAuthorized || status == .justAuthorized {
                    unsafe.updateImage = false
                    unsafe.openCameraOrLibrary()
            } else {
                if status != .justDenied {
                    Utils.alertCameraAccessNeeded()
                }
            }
        })
    }

    func openCameraOrLibrary() {

        let pickerController = DKImagePickerController()
        DKImageExtensionController.registerExtension(extensionClass: CustomCameraExtension.self, for: .camera)
        pickerController.singleSelect = true
        pickerController.showsCancelButton = true
        pickerController.autoCloseOnSingleSelect = true
        pickerController.assetType = .allPhotos
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            if assets.count > 0 {
                self.assignSelectedImages(photos: assets)
            }
        }
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func assignSelectedImages(photos: [DKAsset]) {
        var dkAsset: DKAsset!
        dkAsset = photos[0]
        dkAsset.fetchImage(with: CGSize(width: 740, height: 740), completeBlock: { [weak self] (image, _ ) in
            guard let unsafe = self else { return }
            if image != nil {
                if unsafe.updateImage == false {
                    unsafe.updateImage = true
                    DispatchQueue.main.async {
                        unsafe.photoImage = image
                        var photoData = Data()
                        if (unsafe.photoImage ?? UIImage()).size.width > 0 {
                            photoData = unsafe.photoImage?.jpegData(compressionQuality: 0.8) ?? Data()
                            let param = ["u_photo": photoData] as [String: Any]
                            unsafe.updateProfileImageAPI(param: param)
                        }
                    }
                }
                
            }
        })
    }
}

// MARK: - Medaitor
extension EditProfileViewController {

}

// MARK: - Navigation
extension EditProfileViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == Segues.chooseUniversitySegue {
            if let vc = segue.destination as? ChooseUniversityViewController {
                vc.isEditUserProfile = true
            }
        } else if segue.identifier == Segues.chooseLevelSegue {
            if let vc = segue.destination as? ChooseLevelViewController {
                vc.isEditUserProfile = true
                guard let index = Utils.chooseLevelArray().firstIndex(where: { $0 == profile?.educationLevel ?? "" }) else { return }
                vc.selectedIndex = index
            }
        } else if segue.identifier == Segues.chooseYearSegue {
            if let vc = segue.destination as? ChooseYearViewController {
                guard let index = Utils.chooseYearArray().firstIndex(where: { $0 == profile?.educationYear ?? "" }) else { return }
                vc.selectedIndex = index
                vc.isEditUserProfile = true
            }
        } else if segue.identifier == Segues.addMajorViewSegue {
            if let vc = segue.destination as? AddMajorsViewController {
                vc.selectedArray = minorArray
                vc.isEditUserProfile = true
            }
        } else if segue.identifier == Segues.addMinorViewSegue {
            if let vc = segue.destination as? AddMinorsViewController {
                vc.selectedArray = majorArray
                vc.isEditUserProfile = true
            }
        }
        
    }
}
