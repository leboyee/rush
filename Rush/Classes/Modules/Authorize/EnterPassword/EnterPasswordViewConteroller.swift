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
        numberLabel.passwordFormateLabels()
        symbolLabel.passwordFormateLabels()
        self.bgImageView.setBgForLoginSignup()
        
        if loginType == .Register {
            passwordTitleLabel.text = Text.passwordTitleRegister
            nextButton.setTitle(Text.next, for: .normal)
        }
        else {
            passwordTitleLabel.text = Text.passwordTitleLogin
            nextButton.setTitle(Text.login, for: .normal)
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
        self.performSegue(withIdentifier: Segues.enterPhoneNo, sender: self)
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
