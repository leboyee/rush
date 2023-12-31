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

protocol CreatePostViewControllerDelegate: class {
    func showSnackBar(text: String, buttonText: String)
    func createPostSuccess(_ post: Post)
}

class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var viewBottamConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: CustomView!
    
    var imageList = [Any]()
    var imagedataList = [String: Any]()
    var imagePicker = UIImagePickerController()
    var bigFontCount = 0
    var picker = ImagePickerController()
    weak var delegate: CreatePostViewControllerDelegate?
    var iskeyboard: Bool = false
    var postText = ""
    
    var clubInfo: Club?
    var eventInfo: Event?
    var subclassInfo: SubClass?
    
    var createBtnActive: UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "active-create"), style: .plain, target: self, action: #selector(createButtonAction))
    }
    
    var createBtnDisActive: UIBarButtonItem {
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
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = UIColor.bgBlack
        navigationController?.navigationBar.barTintColor = UIColor.bgBlack
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
    }
    
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        // Setup tableview
        setupTableView()
        
        bottomView.setBackgroundColor()
        
        self.view.backgroundColor = UIColor.bgBlack
        
        // Left item button
        let cancel = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel-active"), style: .plain, target: self, action: #selector(cancelButtonAction))
        navigationItem.leftBarButtonItem = cancel
        
        // Right item button
        navigationItem.rightBarButtonItem = createBtnActive
        
        createButtonValidation()
        
        // Notification's of keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            viewBottamConstraint.constant = UIDevice.current.hasNotch ? (keyboardHeight - 34) : keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        viewBottamConstraint.constant = 0
    }
    
    func createButtonValidation() {
        if postText.isNotEmpty || imageList.count > 0 {
            navigationItem.rightBarButtonItem = createBtnActive
        } else {
            navigationItem.rightBarButtonItem = createBtnDisActive
        }
    }
    
    func close() {
        if navigationController?.viewControllers.count == 1 {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Actions
extension CreatePostViewController {
    
    @IBAction func takePhotoButtonAction(_ sender: Any) {
        if imageList.count >= 10 {
            Utils.alert(message: "Maximum 10 photos are allowed.")
        } else {
            showCameraPermissionPopup()
        }
    }
    
    @IBAction func addPhotoButtonAction(_ sender: Any) {
        showPhotoGallaryPermissionPopup()
    }
    
    @IBAction func cancelButtonAction() {
        close()
        DispatchQueue.main.async {
            self.delegate?.showSnackBar(text: "You didn't finish your post.", buttonText: "Finish it")
        }
    }
    
    @objc func createButtonAction() {
        getImagesDataList(index: 0)
    }
    
}

// MARK: - Imagepicker fuctions
extension CreatePostViewController: ImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: ImagePickerController, shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return true
    }
    
    func imagePickerController(_ picker: ImagePickerController, didFinishPickingImageAssets assets: [PHAsset]) {
        
        let filter = imageList.filter({ $0 as? UIImage != nil })
        
        if (filter.count > 0 && assets.count == 10) || (assets.count + filter.count > 10) {
            picker.dismiss(animated: false, completion: nil)
            Utils.alert(message: "Maximum 10 photos are allowed.")
        } else {
            imageList = assets
            picker.dismiss(animated: false, completion: nil)
            self.picker = ImagePickerController()
            createButtonValidation()
            tableView.reloadData()
        }
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
                
                var parameters = Parameters()
                parameters.allowedSelections = .limit(to: 10)
                self.picker = ImagePickerController(configuration: parameters)
                
                self.picker.delegate = self
                self.picker.navigationBar.isTranslucent = false
                var assets = [PHAsset]()
                for img in self.imageList {
                    if let value = img as? PHAsset { assets.append(value) }
                }
                self.picker.updateSelectedAssets(with: assets)
                self.picker.modalPresentationStyle = .overFullScreen
                self.present(self.picker, animated: false, completion: nil)
            } else {
                // Camera
                let camera = DKCamera()
                camera.didCancel = {
                    self.dismiss(animated: true, completion: nil)
                }
                camera.didFinishCapturingImage = { (image: UIImage?, metadata: [AnyHashable: Any]?) in
                    if var img = image {
                        img = Utils.fixOrientation(img: img)
                        self.imageList.append(img)
                        
                    }
                    self.tableView.reloadData()
                    self.dismiss(animated: true, completion: nil)
                }
                camera.modalPresentationStyle = .fullScreen
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
