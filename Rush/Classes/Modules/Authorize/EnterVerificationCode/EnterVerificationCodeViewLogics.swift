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
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue  {
            isIPhone5 = true
        }
        for char in code {
            if char == "1" {
                let attributedString = NSMutableAttributedString(string: "\(char)")
                attributedString.addAttributes([NSAttributedString.Key.kern : isIPhone5 ? 43.5 : 50.5, NSAttributedString.Key.font : UIFont.DisplayBold(sz: isIPhone5 ? 25 : 30), NSAttributedString.Key.foregroundColor : UIColor.black], range: NSRange(location: 0, length: "\(char)".count))
                mainstring.append(attributedString)
            }
            else {
                let attributedString = NSMutableAttributedString(string: "\(char)")
                attributedString.addAttributes([NSAttributedString.Key.kern : isIPhone5 ? 40 : 47, NSAttributedString.Key.font : UIFont.DisplayBold(sz: isIPhone5 ? 23 : 28), NSAttributedString.Key.foregroundColor : UIColor.black], range: NSRange(location: 0, length: "\(char)".count))
                mainstring.append(attributedString)
            }
        }
        self.codeLabel.attributedText = mainstring

    }
    
    func updateStageView(stage: CodeViewStage) {
        //self_.iconImageView.isHidden = false
        //self_.messageLabel.isHidden = false
        
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
            self.view.layoutIfNeeded()
        } else if stage == .verified {
            self.codeErrorLabel.isHidden = true
            self.codeErrorCancelButton.isHidden = true
            
            
            //Move to Next Screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                if self.loginType == .Register {
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
        self.code = code
        self.updateCodeView(code: self.code)
        if self.code.count == 5 {
            self.nextButton.setNextButton(isEnable: true)
        }
        else {
            self.nextButton.setNextButton(isEnable: false)
        }
    }
}

//MARK: - Manage Interator or API's Calling
extension EnterVerificationCodeViewController {
    
    func signupApiCalled(code : String) {
        let param = [kEmail: profile.email, kPassword: profile.password,kCountry_Code:  profile.countryCode, kPhone: profile.phone, kPhone_token: code] as [String: Any]

        ServiceManager.shared.singup(params: param) {
            [weak self] (status, errorMessage) in
            guard let self_ = self else { return }
            if status {
                self_.singupSuccess()
                //self_.updateViewStage?(.verified)
                /*
                 //Comment due to push is not exist in app
                 //Update Push Token when user is verified successully
                 if let pushToken = Utils.getDataFromUserDefault(kPushToken) as? String {
                 AppDelegate.getInstance().updateToken(deviceTokenString: pushToken, oldPushToken: "")
                 } */
            } else {
                self_.digitTextField.becomeFirstResponder()
                self_.isCodeVerifing = false
                Utils.alert(message: errorMessage ?? "Please contact Admin")
                //self_.updateViewStage?(.error)
            }
        }
    }
    
    func loginApiCalled(code : String) {
        let param = [kPhone_token: code] as [String: Any]
        
        ServiceManager.shared.phonetkn(params: param) {
            [weak self] (status, errorMessage) in
            guard let self_ = self else { return }
            if status {
                self_.singupSuccess()
                //self_.updateViewStage?(.verified)
                /*
                 //Comment due to push is not exist in app
                 //Update Push Token when user is verified successully
                 if let pushToken = Utils.getDataFromUserDefault(kPushToken) as? String {
                 AppDelegate.getInstance().updateToken(deviceTokenString: pushToken, oldPushToken: "")
                 } */
            } else {
                self_.digitTextField.becomeFirstResponder()
                self_.isCodeVerifing = false
                Utils.alert(message: errorMessage ?? "Please contact Admin")
                //self_.updateViewStage?(.error)
            }
        }
    }

    
    func resendCodeApiCalled() {
        Utils.showSpinner()
        let verifyTye = loginType == .Register ? "signup" : "login"
        let countryCodeString = profile.countryCode
        let phoneString = profile.phone
        let param = [kCountry_Code:  countryCodeString, kPhone: phoneString, kVerify_Type: verifyTye] as [String: Any]
        ServiceManager.shared.authPhone(params: param) {
            [weak self] (status, errorMessage) in
            Utils.hideSpinner()
            guard let self_ = self else { return }
            self_.digitTextField.becomeFirstResponder()
            if (status){
                Utils.alert(message: "Code sent successfully.")
            }
            else {
                Utils.alert(message: errorMessage ?? "Please contact Admin")
            }
        }
    }

}
