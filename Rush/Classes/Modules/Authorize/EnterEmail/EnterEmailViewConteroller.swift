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
    @IBOutlet weak var eduLabel: CustomLabel!
    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginNumberButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var termTextView: UITextView!

    var loginType: LoginType = .register
    var profile = User()
    var isEmailError: Bool = false
    var rectTerm: CGRect?
    let termsAndConditionsURL = "https://www.apple.com"
    let privacyURL            = "https://www.google.com"
    
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
        errorButtonAction()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        navigationController?.navigationBar.isHidden = true
    }
    
    //override func viewSafeAreaInsetsDidChange() { print(view.safeAreaInsets) }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
        self.bgImageView.setBgForLoginSignup()
        
        nextButton.setNextButton(isEnable: false)
        emailErroLabel.isHidden = true
        errorButton.isHidden = true
        eduLabel.text = ".edu"
        emailTextField.autocorrectionType = .no

        if loginType == .register {
            loginWithPhoneNumberButton.isHidden = true
            loginLineLable.isHidden = true
            emailTitleLable.text = Text.emailTitleRegister
        } else if loginType == .restoreEmail {
            loginWithPhoneNumberButton.isHidden = true
            loginLineLable.isHidden = true
            emailTitleLable.text = "Enter email to receive restore link"
            nextButton.setTitle("Receive restore link", for: .normal)
        } else {
            termLabel.isHidden = true
            bottomLineLabel.isHidden = true
            loginWithPhoneNumberButton.isHidden = false
            loginLineLable.isHidden = true
            nextButtonBottomConstraint.constant = 0
            loginNumberButtonConstraint.constant = 16
            emailTitleLable.text = Text.emailTitleLogin
            nextButton.setNextButton(isEnable: false)
        }
        
        setTermAndCondition()
    
    }
    
    func setTermAndCondition() {
      
        termTextView.delegate = self
        let yourAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.regular(sz: 13)]
        
        let attributedString = NSMutableAttributedString(string: "By entering your email, you accept our terms and conditions and data policy", attributes: yourAttributes)
        let termRange = (attributedString.string as NSString).range(of: "terms and conditions")
        attributedString.addAttribute(NSAttributedString.Key.link, value: termsAndConditionsURL, range: termRange)
        let dataRange = (attributedString.string as NSString).range(of: "data policy")
        attributedString.addAttribute(NSAttributedString.Key.link, value: privacyURL, range: dataRange)
        let yourOtherAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.brown24, .font: UIFont.regular(sz: 13)]
        termTextView.linkTextAttributes = yourOtherAttributes
        termTextView.attributedText = attributedString
    }

}

// MARK: - Actions
extension EnterEmailViewConteroller {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButtonAction() {
        self.view.endEditing(true)
        var emailText = "\(emailTextField.text ?? "")"
        emailText = emailText.trimmingCharacters(in: .whitespacesAndNewlines)
        if emailText.isValidEmailAddress {
            emailErroLabel.isHidden = true
            errorButton.isHidden = true
            self.view.endEditing(true)
            var email = emailTextField.text ?? ""
            // email = email.replacingOccurrences(of: ".edu", with: ".com")
            profile.email = email
            if loginType == .restoreEmail {
                restorePassword()
            } else {
                checkUserAvailable()
            }
        } else {
            if loginType == .login {
                loginNumberButtonConstraint.constant = 76
                loginLineLable.isHidden = false
            }
            emailErroLabel.isHidden = false
            errorButton.isHidden = false
            nextButton.setNextButton(isEnable: false)
            isEmailError = true
        }
    }
    
    @IBAction func errorButtonAction() {
        emailErroLabel.isHidden = true
        errorButton.isHidden = true
        if loginType == .login {
            loginNumberButtonConstraint.constant = 16
            loginLineLable.isHidden = true
        }
    }
    
    //Login with Phone Number
    @IBAction func loginWithPhoneNumberButtonAction() {
        errorButtonAction()
        self.view.endEditing(true)
        self.performSegue(withIdentifier: Segues.loginPhoneNoSegue, sender: self)
    }
    
}

// MARK: - Navigation
extension EnterEmailViewConteroller {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.enterPassword {
            if let vc = segue.destination as? EnterPasswordViewConteroller {
                vc.loginType = loginType
                vc.profile = profile
            }
        }
        
        if segue.identifier == Segues.loginPhoneNoSegue {
            if let vc = segue.destination as? EnterPhoneNoViewController {
                vc.loginType = loginType
            }
        }
    }
    
}

// MARK: Presenter
extension EnterEmailViewConteroller {
    
    func  emailSuccess() {
        if loginType == .restoreEmail {
            guard let viewControllers = self.navigationController?.viewControllers else { return }
            var isSuccess = false
            for aViewController: UIViewController in viewControllers {
                if aViewController.isKind(of: SettingsViewController.self) {
                    isSuccess = true
                    _ = self.navigationController?.popToViewController(aViewController, animated: true)
                }
            }
            if isSuccess == false {
                for aViewController: UIViewController in viewControllers {
                    if aViewController.isKind(of: EnterEmailViewConteroller.self) {
                        _ = self.navigationController?.popToViewController(aViewController, animated: true)
                    }
                }
            }
        } else {
            self.performSegue(withIdentifier: Segues.enterPassword, sender: self)
        }
    }
    
    func emailErrorHideShow(isHide: Bool) {
        if loginType == .login {
            if isHide == true {
                loginNumberButtonConstraint.constant = 16
                loginLineLable.isHidden = true
            } else {
                loginNumberButtonConstraint.constant = 76
                loginLineLable.isHidden = false
                self.emailErroLabel.isHidden = false
                self.errorButton.isHidden = false
                self.nextButton.setNextButton(isEnable: false)
                self.isEmailError = true
            }
        }
    }
}
