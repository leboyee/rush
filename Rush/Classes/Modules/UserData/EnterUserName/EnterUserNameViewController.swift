//
//  EnterUserNameViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class EnterUserNameViewController: CustomViewController {

    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var userNameTitleLabel: CustomLabel!
    @IBOutlet weak var userNameDetailLabel: CustomLabel!
    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var firstNameTextField: AkiraTextField!
    @IBOutlet weak var lastNameTextField: AkiraTextField!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!

    @IBOutlet weak var pageControllerView: UIView!
    @IBOutlet weak var pageControl: CustomImagePageControl!
    @IBOutlet weak var pageControllerLeadingConstraint: NSLayoutConstraint!

    var loginType: LoginType = .register
    var profile = User()
    var isEditProfile: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNameTextField.autocorrectionType = .yes
        lastNameTextField.autocorrectionType = .yes
        pageControl.updateDots()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)

    }
    
    override func viewWillLayoutSubviews() {
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones5.rawValue {
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    func setup() {
        setupUI()
        setupMediator()
    }
    
    func setupUI() {
        // Navigation Bar Button
        //self.navigationItem.titleView = CustomNavBarPageController.instanceFromNib()
        firstNameTextField.autocapitalizationType = .words
        lastNameTextField.autocapitalizationType = .words
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
            self.firstNameTextField.becomeFirstResponder()
        }
        // Set Custom part of Class
        nextButton.setNextButton(isEnable: false)
        self.bgImageView.setBgForLoginSignup()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        userNameTitleLabel.text = Text.userNameTitleRegister
        nextButton.setTitle(Text.next, for: .normal)
        setCustomNavigationBarView()
    }
    
    // Custom navigation Title View
    func setCustomNavigationBarView() {
        
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: 50)
        let customView = UIView(frame: frame)
        pageControl.isSteps = true
        pageControllerView.frame = CGRect(x: Utils.systemVersionEqualToOrGreterThen(version: "13") ? Utils.isiPhone5() ? -30 : 0 : -112, y: 0, width: screenWidth - 50, height: 50)

        customView.addSubview(pageControllerView)
        self.navigationItem.titleView = customView
        
        let skipButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 76, height: 35))
        skipButton.setImage(UIImage(named: "skipButton"), for: .normal)
        skipButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        /*
            if(isEditProfile == true) {
                pageControl.isHidden = true
                self.navigationItem.rightBarButtonItem = nil
            }*/
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: skipButton)
    }
}

// MARK: - Actions
extension EnterUserNameViewController {
    @objc func backButtonAction() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextButtonAction() {
        firstNameTextField.text = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        lastNameTextField.text = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       // profileUpdateSuccess()
        updateProfileAPI()
    }
}

// MARK: - Navigation
extension EnterUserNameViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.enterPassword {
            if let vc = segue.destination as? EnterPasswordViewConteroller {
                vc.loginType = loginType
            }
        }
    }
}

// MARK: - Preseneter
extension EnterUserNameViewController {
    func profileUpdateSuccess() {
        self.performSegue(withIdentifier: Segues.addProfilePictureSegue, sender: self)
    }
}
