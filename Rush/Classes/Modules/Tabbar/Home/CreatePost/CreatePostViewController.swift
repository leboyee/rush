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

class CreatePostViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var viewBottamConstraint: NSLayoutConstraint!
    var imageList = [UIImage]()
    var imagePicker = UIImagePickerController()
    var iskeyboard : Bool = false
   
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
        openCameraOrLibrary(type: .photoLibrary)
    }
    
    @IBAction func cancelButtonAction() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func createButtonAction() {
        
    }
    
}

// MARK: - Imagepicker fuctions
extension CreatePostViewController {
    // MARK: - Capture Image
    func openCameraOrLibrary( type : UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(type) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = type
                imagePicker.allowsEditing = false
                imagePicker.navigationBar.isTranslucent = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func photoLibraryPermission() {
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            self.openCameraOrLibrary(type: .photoLibrary)
            
        }
            
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
            photoLibraryPermissionAlert()
        }
            
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.openCameraOrLibrary(type: .photoLibrary)
                }
                    
                else {
                    
                }
            })
        }
            
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
            photoLibraryPermissionAlert()
            
        }
    }
    
    func photoLibraryPermissionAlert() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Photo Album",
            message: "Permission is required to add photo.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        
        present(alert, animated: true, completion: nil)
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
