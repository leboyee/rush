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
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var emailErroLabel: CustomLabel!
    @IBOutlet weak var errorButton: CustomButton!

    
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        emailTextField.becomeFirstResponder()
        emailErroLabel.emailErrorSetColor()
        errorButton.setEmailErrorButton()
        nextButton.setNextButton(isEnable: true)
        emailErroLabel.isHidden = true
        errorButton.isHidden = true
        //emailTextField.font = UIFont.DisplayBold(sz: 28)
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
        }
        else {
            emailErroLabel.isHidden = false
            errorButton.isHidden = false
        }
    }
    

}
