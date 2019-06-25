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

protocol CreatePostViewControllerDelegate {
    func showSnackBar(text: String, buttonText: String)
}


class CreatePostViewController: UIViewController {

    @IBOutlet weak var tableView        : UITableView!
    @IBOutlet weak var addPhotoButton   : UIButton!
    @IBOutlet weak var takePhotoButton  : UIButton!
    @IBOutlet weak var viewBottamConstraint: NSLayoutConstraint!
    
    var imageList       = [Any]()
    var imagePicker     = UIImagePickerController()
    var bigFontCount    = 0
    var picker          = ImagePickerController()
    var delegate        : CreatePostViewControllerDelegate?
    var iskeyboard      : Bool = false
    var postText        = ""
    
    
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
        navigationItem.rightBarButtonItem = createBtnActive
        
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
        showCameraPermissionPopup()
    }
    
    @IBAction func addPhotoButtonAction(_ sender: Any) {
        showPhotoGallaryPermissionPopup()
    }
    
    @IBAction func cancelButtonAction() {
        
        self.dismiss(animated: false, completion: nil)
        DispatchQueue.main.async {
            self.delegate?.showSnackBar(text: "You didn't finish your post.", buttonText: "Finish it")
        }
    }
    
    @objc func createButtonAction() {
        performSegue(withIdentifier: Segues.postSegue, sender: nil)
    }
    
}

// MARK: - Imagepicker fuctions
extension CreatePostViewController: ImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: ImagePickerController, shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return true
    }
    
    func imagePickerController(_ picker: ImagePickerController, didFinishPickingImageAssets assets: [PHAsset]) {
        imageList.append(contentsOf: assets)
        picker.dismiss(animated: false, completion: nil)
        self.picker = ImagePickerController()
        createButtonValidation()
        tableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: ImagePickerController) {
        picker.dismiss(animated: false, completion: nil)
    }
    
    
    // MARK: - Capture Image
    func openCameraOrLibrary(type : UIImagePickerController.SourceType) {
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
                
                camera.didFinishCapturingImage = { (image: UIImage?, metadata: [AnyHashable : Any]?) in
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
}

 // MARK: - Navigation
extension CreatePostViewController {
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.postSegue {
            if let vc = segue.destination as? PostViewController {
                vc.imageList = imageList
            }
        }
     }
    
}
