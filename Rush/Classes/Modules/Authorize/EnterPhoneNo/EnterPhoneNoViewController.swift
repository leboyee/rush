//
//  EnterPhoneNoViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class EnterPhoneNoViewController: CustomViewController {

    @IBOutlet weak var phoneNoTextField: CustomTextField!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var phoneNoTitleLabel: CustomLabel!
    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var placeHolderTextField: CustomTextField!

    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var countryButton: UIButton!

    var countryCode: String = "+1"
    var frontTextFiled: String = "+1"
    var profile = Profile()
    var loginType: LoginType = .register
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneNoTextField.autocorrectionType = .no
        phoneNoTextField.keyboardType = .numberPad
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones5.rawValue  {
            placeHolderTextField.font = UIFont.displayBold(sz: 22)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.view.endEditing(true)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    
    
    func setup() {
        setupUI()
        setupMediator()
    }
    
    func setupUI() {
        // Navigation Bar Button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        phoneNoTextField.becomeFirstResponder()
        setContryCodeWith()
        phoneNoTextField.text = self.frontTextFiled
        // Set Custom part of Class
        nextButton.setNextButton(isEnable: false)
        self.bgImageView.setBgForLoginSignup()
        
        if loginType == .register {
            phoneNoTitleLabel.text = Text.phoneNoTitleRegister
            nextButton.setTitle(Text.receiveCodeButtonTitle, for: .normal)
        }
        else {
            phoneNoTitleLabel.text = Text.phoneNoTitleLogin
            nextButton.setTitle(Text.receiveCodeButtonTitle, for: .normal)
        }
        setPlaceHolder()
    }


}

// MARK: - Actions
extension EnterPhoneNoViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButtonAction() {
       //moveToVerificationView()
        Authorization.shared.session = ""
        authPhone()
        //self.performSegue(withIdentifier: Segues.enterPhoneVerification, sender: self)
    }
    
    @IBAction func countryButtonAction() {
        let customPickerStoryboard = UIStoryboard(name: StoryBoard.customPicker, bundle: nil)
        let customPickerController : CustomPickerViewController = customPickerStoryboard.instantiateViewController(withIdentifier: ViewControllerId.customPickerViewController) as! CustomPickerViewController
        customPickerController.pickerDelegate = self
        customPickerController.presenter.type = .country
        customPickerController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        present(customPickerController, animated: false, completion: nil)
    }
}

//MARK: Presenter
extension EnterPhoneNoViewController {
    func moveToVerificationView() {
        self.performSegue(withIdentifier: Segues.enterPhoneVerification, sender: self)
    }
    
    
    
}
// MARK: - Navigation
extension EnterPhoneNoViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.enterPhoneVerification {
            if let vc = segue.destination as? EnterVerificationCodeViewController {
                vc.loginType = loginType
                vc.profile = profile
            }
        }
    }
}
