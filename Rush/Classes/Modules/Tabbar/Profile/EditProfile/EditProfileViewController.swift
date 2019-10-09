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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        title = ""
        tableView.reloadData()
    }
}
// MARK: - Setup
extension EditProfileViewController {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
        
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
       dkAsset.fetchImage(with: CGSize(width: 740, height: 740), completeBlock: { image, _ in
            if let img = image {
                DispatchQueue.main.async {
                    self.userPhotoImageView.image = img.squareImage()
                    self.userImageViewWidthConstraint.constant = 200
                    self.userImageViewHeightConstraint.constant = 200
                    self.userPhotoImageView.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                    self.userPhotoImageView.layer.cornerRadius = 100
                    self.userPhotoImageView.clipsToBounds = true
                    self.bottomLabel.text = Text.changeImage
                    self.nextButton.setNextButton(isEnable: true)
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
        if segue.identifier == Segues.selectEventPhoto {
            if let vc = segue.destination as? SelectEventTypeViewController {
                vc.type = .photo
            }
        } else if segue.identifier == Segues.chooseUniversitySegue {
            if let vc = segue.destination as? ChooseUniversityViewController {
                vc.isEditProfile = true
            }
        } else if segue.identifier == Segues.chooseLevelSegue {
            if let vc = segue.destination as? ChooseLevelViewController {
                vc.isEditProfile = true
            }
        } else if segue.identifier == Segues.chooseYearSegue {
            if let vc = segue.destination as? ChooseYearViewController {
                vc.isEditProfile = true
            }
        } else if segue.identifier == Segues.addMajorViewSegue {
            if let vc = segue.destination as? AddMajorsViewController {
                vc.isEditProfile = true
            }
        } else if segue.identifier == Segues.addMinorViewSegue {
            if let vc = segue.destination as? AddMinorsViewController {
                vc.isEditProfile = true
            }
        }
        
    }
}
