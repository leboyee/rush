//
//  CreateEventViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos
import IQKeyboardManagerSwift

class CreateEventViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraintOfTableView: NSLayoutConstraint!
    
    var imageList = [Any]()
    var imagePicker = UIImagePickerController()
    var picker = ImagePickerController()
    var nameEvent = ""
    var eventDescription = ""
    var address = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var eventImage: UIImage?
    var startDate = Date()
    var endDate = Date()
    var startTime = ""
    var endTime = ""
    var calendarHeight: CGFloat = 352.0
    var isStartDate: Bool = false
    var isEndDate: Bool = false
    var isStartTime: Bool = false
    var isEndTime: Bool = false
    
    var cancelBtn: UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "cancel-active"), style: .plain, target: self, action: #selector(cancelButtonAction))
    }
    
    var saveBtnActive: UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "save-active"), style: .plain, target: self, action: #selector(saveButtonAction))
    }
    
    var saveBtnDisActive: UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "save-dark"), style: .plain, target: self, action: nil)
    }
    
    var interestList = [String]()
    var rsvpArray = [String]()
    var peopleList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.isTranslucent = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
 
    // MARK: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        
        topConstraintOfTableView.constant = -Utils.navigationHeigh
        definesPresentationContext = true
        // Set navigation buttons
        navigationItem.leftBarButtonItem = cancelBtn
        navigationItem.rightBarButtonItem = saveBtnDisActive
        
        // Setup tableview
        setupTableView()
        
        /*
        let total = screenWidth + 15
        
        topConstraintOfTapToChangeLabel.constant = total - 106
        heightConstraintOfImageView.constant = total
        
        scrollView.contentInset = UIEdgeInsets(top: (total - Utils.navigationHeigh)*0.81, left: 0, bottom: 0, right: 0)
        
        
        if userImageView.image != nil {
            addPhotoButton.isHidden = true
            navigationItem.rightBarButtonItem = saveBtnActive
        } else {
            hoverView.isHidden = true
            addPhotoButton.isHidden = false
           navigationItem.rightBarButtonItem = saveBtnDisActive
        }
        */
    }
}

// MARK: - Actions
extension CreateEventViewController {
    @IBAction func cancelButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonAction() {

    }
    
    @IBAction func addImageButtonAction() {
        self.performSegue(withIdentifier: Segues.selectEventPhoto, sender: self)
    }
}

// MARK: - Mediator
extension CreateEventViewController {
    func selectedCell(_ indexPath: IndexPath) {
        
        if indexPath.section == 0  || indexPath.section == 1 {
            
        } else if indexPath.section == 2 {
               DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segues.addRSVP, sender: self)
            }
        } else if indexPath.section == 3 {
            self.performSegue(withIdentifier: Segues.addLocation, sender: self)
        } else {
            Utils.alert(message: "In Development")
        }
        
    }
    
    func addImageFunction() {
        self.performSegue(withIdentifier: Segues.selectEventPhoto, sender: self)
    }
}

// MARK: - Navigation
extension CreateEventViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.selectEventPhoto {
            if let vc = segue.destination as? SelectEventTypeViewController {
                vc.type = .photo
                vc.delegate = self
            }
        } else if segue.identifier == Segues.addRSVP {
            if let vc = segue.destination as? AddRSVPViewController {
                vc.delegate = self
            }
        } else if segue.identifier == Segues.addLocation {
            if let vc = segue.destination as? AddLocationViewController {
                vc.delegate = self
            }
        }
        
    }
}

// MARK: - Imagepicker fuctions
extension CreateEventViewController: ImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: ImagePickerController, shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return true
    }
    
    func imagePickerController(_ picker: ImagePickerController, didFinishPickingImageAssets assets: [PHAsset]) {
        imageList = assets
        picker.dismiss(animated: false, completion: nil)
        DispatchQueue.main.async {
            self.setEventImage(imageAsset: self.imageList[0])
            self.validateAllFields()
            self.tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: ImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Capture Image
    func openCameraOrLibrary(type: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            if type == .photoLibrary {
                let status = PHPhotoLibrary.authorizationStatus()
                guard status == .authorized else {
                    Utils.photoLibraryPermissionAlert()
                    return
                }
            } else {
                let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                guard status == .authorized else {
                    Utils.alertCameraAccessNeeded()
                    return
                }
            }
            
            if type == .photoLibrary {
                self.picker = ImagePickerController()
                self.picker.delegate = self
                self.picker.navigationBar.isTranslucent = false
                var assets = [PHAsset]()
                for img in self.imageList {
                    if let value = img as? PHAsset { assets.append(value) }
                }
                self.picker.updateSelectedAssets(with: assets)
                self.present(self.picker, animated: false, completion: nil)
            } else {
                // Camera
                let camera = DKCamera()
                camera.didCancel = {
                    self.dismiss(animated: true, completion: nil)
                }
                
                camera.didFinishCapturingImage = { (image: UIImage?, metadata: [AnyHashable: Any]?) in
                    if let img = image { self.imageList.append(img) }
                    self.tableView.reloadData()
                    self.dismiss(animated: true, completion: nil)
                }
                self.present(camera, animated: true, completion: nil)
            }
        }
    }
    
    private func showCameraPermissionPopup() {
        // Camera
        Utils.authorizeVideo { (status) in
            switch status {
            case .justDenied:
                break
            case .alreadyDenied:
                Utils.alertCameraAccessNeeded()
            case .restricted:
                Utils.alertCameraAccessNeeded()
            case .justAuthorized:
                self.openCameraOrLibrary(type: .camera)
            case .alreadyAuthorized:
                self.openCameraOrLibrary(type: .camera)
            }
        }
    }
    
    private func showPhotoGallaryPermissionPopup() {
        Utils.authorizePhoto { (status) in
            switch status {
            case .justDenied:
                break
            case .alreadyDenied:
                Utils.photoLibraryPermissionAlert()
            case .restricted:
                Utils.photoLibraryPermissionAlert()
            case .justAuthorized:
                self.openCameraOrLibrary(type: .photoLibrary)
            case .alreadyAuthorized:
                self.openCameraOrLibrary(type: .photoLibrary)
            }
        }
    }
    
    func setEventImage(imageAsset: Any) {
        if let asset = imageAsset as? PHAsset {
            let imageSize = CGSize(
                width: screenWidth * UIScreen.main.scale,
                height: screenWidth * UIScreen.main.scale
            )
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.resizeMode = .exact
            requestOptions.isNetworkAccessAllowed = true
            
            PHCachingImageManager.default().requestImage(
                for: asset,
                targetSize: imageSize,
                contentMode: .aspectFill,
                options: requestOptions
            ) { [weak self] image, _ in
                guard let unself = self else { return }
                if let image = image {
                    unself.eventImage = image
                }
            }
        } else if let image = imageAsset as? UIImage {
            eventImage = image
        }
    }
}
