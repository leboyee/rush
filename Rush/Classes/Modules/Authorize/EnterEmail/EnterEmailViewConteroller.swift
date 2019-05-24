//
//  EnterEmailViewConteroller.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class EnterEmailViewConteroller: CustomViewController {

    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var emailErroLabel: CustomLabel!
    @IBOutlet weak var emailTitleLable: CustomLabel!
    @IBOutlet weak var errorButton: CustomButton!
    @IBOutlet weak var loginWithPhoneNumberButton: CustomButton!
    @IBOutlet weak var bottomLineLabel: CustomLabel!
    @IBOutlet weak var loginLineLable: CustomLabel!
    @IBOutlet weak var termLabel: CustomEmailAttributedLabel!

    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginNumberButtonConstraint: NSLayoutConstraint!


    var loginType: LoginType = .Register
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.autocorrectionType = .no
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
        navigationController?.navigationBar.isHidden = true

    }

    
    func setup() {
        setupUI()
        setupMediator()
    }
    
    func setupUI() {
        // Navigation Bar Button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        emailTextField.becomeFirstResponder()
        
        // Set Custom part of Class
        emailErroLabel.emailErrorSetColor()
        errorButton.setEmailErrorButton()
        loginWithPhoneNumberButton.setLoginWithNumberButton()
        emailTitleLable.emailScreenTitleLabel()
        
        
        nextButton.setNextButton(isEnable: true)
        emailErroLabel.isHidden = true
        errorButton.isHidden = true
        
        if loginType == .Register {
            loginWithPhoneNumberButton.isHidden = true
            loginLineLable.isHidden = true
            emailTitleLable.text = Text.emailTitleRegister
        }
        else {
            termLabel.isHidden = true
            bottomLineLabel.isHidden = true
            loginWithPhoneNumberButton.isHidden = false
            loginLineLable.isHidden = true
            nextButtonBottomConstraint.constant = 0
            loginNumberButtonConstraint.constant = 16
            emailTitleLable.text = Text.emailTitleLogin
        }
    }


}

// MARK: - Actions
extension EnterEmailViewConteroller {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButtonAction() {
        let emailText = "\(emailTextField.text ?? "").edu"
        if emailText.isValidEmailAddress {
            emailErroLabel.isHidden = true
            errorButton.isHidden = true
            self.view.endEditing(true)
            self.performSegue(withIdentifier: Segues.enterPassword, sender: self)
        }
        else {
            if loginType == .Login {
                loginNumberButtonConstraint.constant = 76
                loginLineLable.isHidden = false
            }
            emailErroLabel.isHidden = false
            errorButton.isHidden = false
        }
    }
    
    @IBAction func errorButtonAction() {
        emailErroLabel.isHidden = true
        errorButton.isHidden = true
        if loginType == .Login {
            loginNumberButtonConstraint.constant = 16
            loginLineLable.isHidden = true
        }
    }
    
}

// MARK: - Navigation
extension EnterEmailViewConteroller {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.enterPassword {
            if let vc = segue.destination as? EnterPasswordViewConteroller {
                vc.loginType = loginType
            }
        }
    }
    
}
