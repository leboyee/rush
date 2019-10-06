//
//  EditProfileViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 04/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var imageList = [Any]()
    var imagePicker = UIImagePickerController()
    var picker = ImagePickerController()
    var eventImage: UIImage?
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

// MARK: - Medaitor
extension EditProfileViewController {
    
    func addImageFunction() {
        self.performSegue(withIdentifier: Segues.selectEventPhoto, sender: self)
    }
}

// MARK: - Imagepicker fuctions
extension EditProfileViewController: ImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: ImagePickerController, shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return true
    }
    
    func imagePickerController(_ picker: ImagePickerController, didFinishPickingImageAssets assets: [PHAsset]) {
        imageList = assets
        picker.dismiss(animated: false, completion: nil)
        DispatchQueue.main.async {
            //self.setEventImage(imageAsset: self.imageList[0])
            
            self.tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: ImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Capture Image
    func openCameraOrLibrary(type: UIImagePickerController.SourceType) {
        
    }
}

// MARK: - TableView
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
