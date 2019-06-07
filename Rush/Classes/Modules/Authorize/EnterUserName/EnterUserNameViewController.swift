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

    var loginType: LoginType = .Register
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNameTextField.autocorrectionType = .no
        lastNameTextField.autocorrectionType = .no

        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
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
        // Navigation Bar Button
        //self.navigationItem.titleView = CustomNavBarPageController.instanceFromNib()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { // Change `2.0` to the desired number of seconds.
            self.firstNameTextField.becomeFirstResponder()
        }
        // Set Custom part of Class
        nextButton.setNextButton(isEnable: false)
        self.bgImageView.setBgForLoginSignup()
        userNameTitleLabel.text = Text.userNameTitleRegister
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

// MARK: - Actions
extension EnterUserNameViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButtonAction() {
        AppDelegate.getInstance().setupStoryboard()
    }

}
