//
//  EnterUserNameViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DKImagePickerController
import DKPhotoGallery
import DKCamera


class AddProfilePictureViewController: CustomViewController {

    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!

    var loginType: LoginType = .Register
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewWillLayoutSubviews() {
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue  {
        }
    }
    

    
    //MARK: - Setup
    func setup() {
        setupUI()
        setupMediator()
    }
    
    func setupUI() {

        // Set Custom part of Class
        nextButton.setNextButton(isEnable: false)
        self.bgImageView.setBgForLoginSignup()
        nextButton.setTitle(Text.next, for: .normal)
        setCustomNavigationBarView()
    }
    
    // Custom navigation Title View
    func setCustomNavigationBarView() {
        

        let frame = CGRect(x: 0, y: 0, width: screenWidth , height: 50)
        let customView = UIView(frame: frame)
        let customNavPageView = CustomNavBarPageController()
        let pageView = customNavPageView.instanceFromNib()
        pageView.frame = CGRect(x: -112, y: 0, width: screenWidth - 50 , height: 50)
        customView.addSubview(pageView)
        self.navigationItem.titleView = customView
        
        let skipButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 76, height: 35))
        skipButton.setImage(UIImage(named: "skipButton"), for: .normal)
        skipButton.addTarget(self, action:  #selector(backButtonAction), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))

        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: skipButton)
    }
}

//MARK: - Other Function
extension AddProfilePictureViewController {
    
    func photoLibraryPermissionCheck() {
        Utils.authorizePhoto(completion: { [weak self] (status) in
            guard let self_ = self else { return }
            if status == .alreadyAuthorized || status == .justAuthorized {
                    self_.openCameraOrLibrary()
            }
            else {
                if status != .justDenied {
                    Utils.photoLibraryPermissionAlert()
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
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            self.assignSelectedImages(photos: assets)
        }

        self.present(pickerController, animated: true, completion: nil)
    }
    
    func assignSelectedImages(photos: [DKAsset]) {
        var dkAsset: DKAsset!
        dkAsset = photos[0]
       dkAsset.fetchImage(with: CGSize(width: 740, height: 740), completeBlock: { image, info in
            if let img = image {
                self.userPhotoImageView.image = img

                DispatchQueue.main.async {
                    self.userImageViewWidthConstraint.constant = 200
                    self.userImageViewHeightConstraint.constant = 200
                    self.userPhotoImageView.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                    self.userPhotoImageView.layer.cornerRadius = 100
                    self.userPhotoImageView.clipsToBounds = true
                    self.bottomLabel.text = Text.changeImage
                }
            }
        })
    }
}

// MARK: - Actions
extension AddProfilePictureViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButtonAction() {
        AppDelegate.getInstance().setupStoryboard()
    }
    
    @IBAction func addImageViewButtonAction() {
        photoLibraryPermissionCheck()
    }
}
