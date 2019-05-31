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

    var code = ""
    var isCodeVerifing = false
    var phoneNumber = ""
    var countryCode = ""


    var loginType: LoginType = .Register
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        digitTextField.autocorrectionType = .no
        digitTextField.keyboardType = .numberPad
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
    
    func setup() {
        setupUI()
        setupMediator()
    }
    
    func setupUI() {
        // Navigation Bar Button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        digitTextField.becomeFirstResponder()

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
           // self.isCodeVerifing = true
            //API calling for Code Verifing by server
           // self.codeVerifyingAPI(code: self.code)
            //Update View
           // self.updateStageView(stage: .verifying)
            AppDelegate.getInstance().setupStoryboard()
        }

    }
    
    @IBAction func resendSMSButtonAction() {
        view.endEditing(true)
    }
    
}
