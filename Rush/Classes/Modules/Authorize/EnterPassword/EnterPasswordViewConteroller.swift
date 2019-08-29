//
//  EnterPasswordViewConteroller.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class EnterPasswordViewConteroller: CustomViewController {

    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var passwordTitleLabel: CustomLabel!
    @IBOutlet weak var passwordShowHideLabel: CustomLabel!
    @IBOutlet weak var capitalLetterDotView: CustomView!
    @IBOutlet weak var numberDotView: CustomView!
    @IBOutlet weak var symbolDotView: CustomView!
    @IBOutlet weak var capitalLetterLabel: CustomLabel!
    @IBOutlet weak var numberLabel: CustomLabel!
    @IBOutlet weak var symbolLabel: CustomLabel!
    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordShowButton: UIButton!
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var passwordErrorLabel: CustomLabel!
    @IBOutlet weak var passwordErrorView: UIView!
    @IBOutlet weak var restorePasswordButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var resortPasswordButton: CustomButton!
    @IBOutlet weak var errorButton: CustomButton!

    var loginType: LoginType = .Register
    var profile = Profile()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        navigationController?.navigationBar.isHidden = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.view.endEditing(true)
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
        passwordTextField.becomeFirstResponder()
        passwordShowHideLabel.isHidden = true
        
        // Set Custom part of Class
        nextButton.setNextButton(isEnable: false)
        capitalLetterDotView.setPasswordDotColorView(index: .none)
        numberDotView.setPasswordDotColorView(index: .none)
        symbolDotView.setPasswordDotColorView(index: .none)
        capitalLetterLabel.passwordFormateLabels()
        passwordErrorLabel.emailErrorSetColor()
        numberLabel.passwordFormateLabels()
        symbolLabel.passwordFormateLabels()
        errorButton.setEmailErrorButton()
        self.bgImageView.setBgForLoginSignup()
        restorePasswordButtonConstraint.constant = 16
        if loginType == .Register {
            passwordTitleLabel.text = Text.passwordTitleRegister
            nextButton.setTitle(Text.next, for: .normal)
            resortPasswordButton.isHidden = true
            hintView.isHidden = false
            passwordErrorView.isHidden = true
        }
        else {
            passwordTitleLabel.text = Text.passwordTitleLogin
            nextButton.setTitle(Text.login, for: .normal)
            hintView.isHidden = true
            resortPasswordButton.isHidden = false
            passwordErrorView.isHidden = true
        }
    }


}

// MARK: - Actions
extension EnterPasswordViewConteroller {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButtonAction() {
        profile.password = passwordTextField.text ?? ""
        self.view.endEditing(true)
        if loginType == .Login {
            Authorization.shared.session = ""
            loginApiCalled()
        }
        else {
            self.performSegue(withIdentifier: Segues.enterPhoneNo, sender: self)
        }
        
    }
    
    @IBAction func passwordShowHideButton() {
        if passwordShowButton.isSelected == true {
            passwordShowHideLabel.text = Text.show
            passwordShowButton.isSelected = false
            passwordTextField.isSecureTextEntry = true
        }
        else {
            passwordTextField.isSecureTextEntry = false
            passwordShowHideLabel.text = Text.hide
            passwordShowButton.isSelected = true
        }
    }
    
    @IBAction func errorButtonAction() {
        if loginType == .Login {
            passwordErrorView.isHidden = true
            restorePasswordButtonConstraint.constant = 16
        }
    }
    
    @IBAction func restoreButtonAction() {
        Utils.alert(message: "In Development.")
    }


}

// MARK: - Navigation
extension EnterPasswordViewConteroller {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.enterPhoneNo {
            if let vc = segue.destination as? EnterPhoneNoViewController {
                vc.loginType = loginType
                vc.profile = profile
            }
        }
    }
    
}


// MARK: - Preseneter
extension EnterPasswordViewConteroller {
    
    func profileUpdateSuccess(){
        AppDelegate.getInstance().setupStoryboard()
    }
    
    func passwordNotSuccess() {
        passwordErrorHideShow(isHide: false)
    }
    
    func passwordErrorHideShow(isHide: Bool) {
        if loginType == .Login {
            if isHide == true {
                restorePasswordButtonConstraint.constant = 16
                passwordErrorView.isHidden = true
            }
            else {
                restorePasswordButtonConstraint.constant = 76
                passwordErrorView.isHidden = false
                self.nextButton.setNextButton(isEnable: false)
            }
        }
    }

}
