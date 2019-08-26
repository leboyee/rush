//
//  EnterVerificationCodeViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

enum CodeViewStage {
    case start
    case verifying
    case error
    case verified
}

class EnterVerificationCodeViewController: CustomViewController {

    @IBOutlet weak var digitTextField: CustomTextField!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var verificationTitleLabel: CustomLabel!
    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var resendCodeButton: CustomButton!
    @IBOutlet weak var codeLabel : CustomLabel!
    @IBOutlet weak var codeErrorLabel : CustomLabel!
    @IBOutlet weak var codeErrorCancelButton : CustomButton!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var codeViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var codeLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var codeLabelLeadingConstraint: NSLayoutConstraint!

    var code = ""
    var isCodeVerifing = false
    var phoneNumber = ""
    var countryCode = ""


    var loginType: LoginType = .Register
    var profile = Profile()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        digitTextField.autocorrectionType = .no
        digitTextField.keyboardType = .numberPad
        digitTextField.becomeFirstResponder()
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
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones5.rawValue  {
            codeViewWidthConstraint.constant =  270
            codeLabelLeadingConstraint.constant = 16
            codeLabelWidthConstraint.constant = 280
        }

    }
    
    //MARK: - Setup
    func setup() {
        setupUI()
        setupMediator()
    }
    
    func setupUI() {
        // Navigation Bar Button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))

        // Set Custom part of Class
        nextButton.setNextButton(isEnable: false)
        codeErrorCancelButton.isHidden = true
        codeErrorLabel.isHidden = true
        self.bgImageView.setBgForLoginSignup()
        
        if loginType == .Register {
            verificationTitleLabel.text = Text.phoneNoTitleRegister
            nextButton.setTitle(Text.createAccount, for: .normal)
        }
        else {
            verificationTitleLabel.text = Text.phoneNoTitleLogin
            nextButton.setTitle(Text.login, for: .normal)
        }
    }


}

// MARK: - Actions
extension EnterVerificationCodeViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButtonAction() {
        if self.code.count == 5 {
            self.view.endEditing(true)
            if loginType == .Register {
                signupApiCalled(code: self.code)
            }
            else {
                loginApiCalled(code: self.code)
            }
            //self.performSegue(withIdentifier: Segues.enterUserNameSegue, sender: self)
            //AppDelegate.getInstance().setupStoryboard()
        }

    }
    
    @IBAction func resendSMSButtonAction() {
        codeLabel.text = ""
        digitTextField.text = ""
        resendCodeApiCalled()
        //view.endEditing(true)
    }
}

//MARK: Presenter
extension EnterVerificationCodeViewController {
    func singupSuccess() {
        self.performSegue(withIdentifier: Segues.enterUserNameSegue, sender: self)
    }
    
    func loginSuccess() {
        AppDelegate.shared?.setupStoryboard()

    }
    
}


// MARK: - Navigation
extension EnterVerificationCodeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.enterUserNameSegue {
            if let vc = segue.destination as? EnterUserNameViewController {
                vc.loginType = loginType
                vc.profile = profile
            }
        }
    }
}
