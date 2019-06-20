//
//  CreatePostViewController.swift
//  Rush
//
//  Created by ideveloper2 on 12/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos
import IQKeyboardManagerSwift
import DKImagePickerController

class CreatePostViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var viewBottamConstraint: NSLayoutConstraint!
    var imageList = [PHAsset]()
    var imagePicker = UIImagePickerController()
    var iskeyboard : Bool = false
    var picker = ImagePickerController()
   
    var postText = ""
    
    var createBtnActive : UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "active-create"), style: .plain, target: self, action: #selector(createButtonAction))
    }
    
    var createBtnDisActive : UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "create-inactive"), style: .plain, target: self, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    func setup() {
        setupUI()
    }
    
    
    func setupUI() {
        // Setup tableview
        setupTableView()
        
        navigationController?.navigationBar.isTranslucent = false
    
        // Left item button
        let cancel = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel-active"), style: .plain, target: self, action: #selector(cancelButtonAction))
        navigationItem.leftBarButtonItem = cancel
        
        // Right item button
        navigationItem.rightBarButtonItem = createBtnDisActive
        
        // Notification's of keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            viewBottamConstraint.constant = keyboardHeight + (Utils.isHasSafeArea ? -34 : 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        viewBottamConstraint.constant = 0
    }
    
    func createButtonValidation() {
        if postText.isNotEmpty && imageList.count > 0 {
            navigationItem.rightBarButtonItem = createBtnActive
        } else {
            navigationItem.rightBarButtonItem = createBtnDisActive
        }
    }
}

// MARK:- Actions
extension CreatePostViewController {
    
    @IBAction func takePhotoButtonAction(_ sender: Any) {
        openCameraOrLibrary(type: .camera)
    }
    
    @IBAction func addPhotoButtonAction(_ sender: Any) {
        picker = ImagePickerController()
        picker.delegate = self
        picker.navigationBar.isTranslucent = false
        present(picker, animated: false, completion: nil)
    }
    
    @IBAction func cancelButtonAction() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func createButtonAction() {
        
    }
    
}

// MARK: - Imagepicker fuctions
extension CreatePostViewController: ImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: ImagePickerController, shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return true
    }
    
    func imagePickerController(_ picker: ImagePickerController, didFinishPickingImageAssets assets: [PHAsset]) {
        imageList = assets
        picker.dismiss(animated: false, completion: nil)
        self.picker = ImagePickerController()
        tableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: ImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }
    
    
    func photoLibraryPermissionCheck(type : DKImageExtensionType) {
        if type == .gallery {
            Utils.authorizePhoto(completion: { [weak self] (status) in
                guard let self_ = self else { return }
                if status == .alreadyAuthorized || status == .justAuthorized {
                    self_.openCameraOrLibrary(type: type)
                }
                else {
                    if status != .justDenied {
                        Utils.photoLibraryPermissionAlert()
                    }
                }
            })
        } else {
            showCameraPermissionPopup()
        }
    }
    
    // MARK: - Capture Image
    func openCameraOrLibrary(type : DKImageExtensionType) {
        let pickerController = DKImagePickerController()
        DKImageExtensionController.registerExtension(extensionClass: CustomCameraExtension.self, for: type)
        
        pickerController.singleSelect = false
        pickerController.showsCancelButton = true
        pickerController.autoCloseOnSingleSelect = false
        pickerController.allowMultipleTypes = true
        pickerController.assetType = .allPhotos
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
//            self.assignSelectedImages(photos: assets)
        }
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    
    private func showCameraPermissionPopup() {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied:
            NSLog("cameraAuthorizationStatus=denied")
            self.alertCameraAccessNeeded()
            break
        case .authorized:
            NSLog("cameraAuthorizationStatus=authorized")
            openCameraOrLibrary(type: .camera)
            break
        case .restricted:
            NSLog("cameraAuthorizationStatus=restricted")
            self.alertCameraAccessNeeded()
            break
        case .notDetermined:
            NSLog("cameraAuthorizationStatus=notDetermined")
            
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                DispatchQueue.main.sync {
                    if granted {
                        // do something
                        self.openCameraOrLibrary(type: .camera)
                    } else {
                        // do something else
                    }
                }
            }
        @unknown default:
            break
        }
    }
    
    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Camera Access",
            message: "Camera access is required to make full use of this app.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

 // MARK: - Navigation
extension CreatePostViewController {
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }
     */
}
