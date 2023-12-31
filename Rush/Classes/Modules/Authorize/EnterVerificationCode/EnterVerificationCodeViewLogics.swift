//
//  EnterVerificationCodeViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension EnterVerificationCodeViewController {
    
    func updateCodeView(code: String) {
        let mainstring = NSMutableAttributedString.init()
        var isIPhone5 = false
        if UIDevice.current.screenType == UIDevice.ScreenType.iPhones5 {
            isIPhone5 = true
        }
       
        for char in code {
            if char == "1" {
                let attributedString = NSMutableAttributedString(string: "\(char)")
                attributedString.addAttributes([NSAttributedString.Key.kern: isIPhone5 ? 43.5 : 50.5, NSAttributedString.Key.font: UIFont.displayBold(sz: isIPhone5 ? 25 : 30), NSAttributedString.Key.foregroundColor: UIColor.black], range: NSRange(location: 0, length: "\(char)".count))
                mainstring.append(attributedString)
            } else {
                let attributedString = NSMutableAttributedString(string: "\(char)")
                attributedString.addAttributes([NSAttributedString.Key.kern: isIPhone5 ? 40 : 47, NSAttributedString.Key.font: UIFont.displayBold(sz: isIPhone5 ? 23 : 28), NSAttributedString.Key.foregroundColor: UIColor.black], range: NSRange(location: 0, length: "\(char)".count))
                mainstring.append(attributedString)
            }
        }
        self.codeLabel.attributedText = mainstring

    }
    
    func updateStageView(stage: CodeViewStage) {
        //self_.iconImageView.isHidden = false
        //self_.messageLabel.isHidden = false
        self.nextButton.setNextButton(isEnable: true)
        if stage == .start {
            self.codeErrorLabel.isHidden = true
            self.codeErrorCancelButton.isHidden = true
          //  let message = String(format: Message.startMessage,"+\(self_.presenter.countryCode)-\(self_.presenter.phoneNumber)")
           // self.messageLabel.text = message
        } else if stage == .verifying {
            self.codeErrorLabel.isHidden = true
            //self.messageLabel.isHidden = true
            self.codeErrorCancelButton.isHidden = true
        } else if stage == .error {
            //self_.messageLabel.isHidden = true
            self.codeErrorLabel.isHidden = false
            self.codeErrorCancelButton.isHidden = false
            self.nextButton.setNextButton(isEnable: false)
            self.view.layoutIfNeeded()
        } else if stage == .verified {
            self.codeErrorLabel.isHidden = true
            self.codeErrorCancelButton.isHidden = true
            //Move to Next Screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                if self.loginType == .register {
                   // self.performSegue(withIdentifier: Segues.phoneVerificationToUserTypeViewSegue, sender: nil)
                } else {
//                    let profile = Profile(data: Authorization.shared.getUserData() ?? [:])
//                    if profile.userType == .none {
//                        self_.performSegue(withIdentifier: Segues.phoneVerificationToUserTypeViewSegue, sender: nil)
//                    }
//                    else {
//                        //Move to setting screen again.
//                        AppDelegate.getInstance().setTabbar()
//                    }
                }
            }
        }
    }
    
    func updateCode(code: String) {
        guard self.isCodeVerifing == false else { return }
        self.resendCodeButton.setImage(nil, for: .normal)
        self.resendCodeButton.setTitle("Resend Code", for: .normal)
        self.resendCodeButton.isUserInteractionEnabled = true
                        //Utils.alert(message: "Code sent successfully.")
        self.code = code
        self.updateCodeView(code: self.code)
        if self.code.count == 5 {
            self.nextButton.setNextButton(isEnable: true)
        } else {
            self.nextButton.setNextButton(isEnable: false)
        }
    }
}

// MARK: - Manage Interator or API's Calling
extension EnterVerificationCodeViewController {
    
    func signupApiCalled(code: String) {
        let param = [Keys.email: profile.email ?? "", Keys.password: profile.password ?? "", Keys.countryCode: profile.countryCode ?? "", Keys.phone: profile.phone ?? "", Keys.phoneToken: code] as [String: Any]

        ServiceManager.shared.singup(params: param) { [weak self] (status, _) in
            guard let unsafe = self else { return }
            if status {
                if Utils.getDataFromUserDefault(kPushToken) != nil {
                    //API call and when success
                    ServiceManager.shared.updatePushToken(closer: { (status, _) in
                        if status {
                        }
                    })
                }
                unsafe.singupSuccess()
                
            } else {
                unsafe.digitTextField.becomeFirstResponder()
                unsafe.isCodeVerifing = false
                //Utils.alert(message: errorMessage ?? "Please contact Admin")
                unsafe.updateStageView(stage: .error)
            }
        }
    }
    
    func loginApiCalled(code: String) {
        let param = [Keys.phoneToken: code] as [String: Any]
        
        ServiceManager.shared.phonetkn(params: param) { [weak self] (status, _) in
            guard let unsafe = self else { return }
            if status {
                unsafe.loginSuccess()
                //self_.updateViewStage?(.verified)
                /*
                 //Comment due to push is not exist in app
                 //Update Push Token when user is verified successully
                 if let pushToken = Utils.getDataFromUserDefault(kPushToken) as? String {
                 AppDelegate.getInstance().updateToken(deviceTokenString: pushToken, oldPushToken: "")
                 } */
            } else {
                unsafe.digitTextField.becomeFirstResponder()
                unsafe.isCodeVerifing = false
                //Utils.alert(message: errorMessage ?? "Please contact Admin")
                unsafe.updateStageView(stage: .error)
            }
        }
    }
    
    func resendCodeApiCalled() {
        resendCodeButton.setTitle("", for: .normal)
        dotView.ajShowDotLoadingIndicator()
        dotAnimationView.isHidden = false
        resendCodeButton.isUserInteractionEnabled = false
        //Utils.showSpinner()
        let verifyTye = loginType == .register ? "signup" : "login"
        let countryCodeString = profile.countryCode
        let phoneString = profile.phone
        let param = [Keys.countryCode: countryCodeString ?? "", Keys.phone: phoneString ?? "", Keys.verifyType: verifyTye] as [String: Any]
        ServiceManager.shared.authPhone(params: param) { [weak self] (status, errorMessage) in
            //Utils.hideSpinner()
           
            guard let unsafe = self else { return }
            unsafe.dotView.ajHideDotLoadingIndicator()
            unsafe.dotAnimationView.isHidden = true
            unsafe.digitTextField.becomeFirstResponder()
            if status {
                unsafe.resendCodeButton.setTitle("Sent", for: .normal)
                unsafe.resendCodeButton.setImage(#imageLiteral(resourceName: "sentTick"), for: .normal)
                unsafe.nextButton.setNextButton(isEnable: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                    unsafe.resendCodeButton.isUserInteractionEnabled = true
                    unsafe.resendCodeButton.setImage(nil, for: .normal)
                    unsafe.resendCodeButton.setTitle("Resend Code", for: .normal)
                    unsafe.resendCodeButton.isUserInteractionEnabled = true
                })

            } else {
                
                Utils.alert(message: errorMessage ?? "Please contact Admin")
            }
        }
    }

}
