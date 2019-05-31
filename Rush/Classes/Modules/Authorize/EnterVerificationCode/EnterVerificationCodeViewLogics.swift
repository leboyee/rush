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
        for char in code {
            if char == "1" {
                let attributedString = NSMutableAttributedString(string: "\(char)")
                attributedString.addAttributes([NSAttributedString.Key.kern : 50.5, NSAttributedString.Key.font : UIFont.DisplayBold(sz: 30), NSAttributedString.Key.foregroundColor : UIColor.black], range: NSRange(location: 0, length: "\(char)".count))
                mainstring.append(attributedString)
            }
            else {
                let attributedString = NSMutableAttributedString(string: "\(char)")
                attributedString.addAttributes([NSAttributedString.Key.kern : 47, NSAttributedString.Key.font : UIFont.DisplayBold(sz: 28), NSAttributedString.Key.foregroundColor : UIColor.black], range: NSRange(location: 0, length: "\(char)".count))
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
    
    func codeVerifyingAPI(code : String) {
//        ServiceManager.shared.phonetkn(params: [kToken : code]) {
//            [weak self] (status, errorMessage) in
//            guard let self_ = self else { return }
//            if status {
//                self_.updateViewStage?(.verified)
//
//                /*
//                 //Comment due to push is not exist in app
//                 //Update Push Token when user is verified successully
//                 if let pushToken = Utils.getDataFromUserDefault(kPushToken) as? String {
//                 AppDelegate.getInstance().updateToken(deviceTokenString: pushToken, oldPushToken: "")
//                 } */
//            } else {
//                self_.isCodeVerifing = false
//                self_.updateViewStage?(.error)
//            }
//        }
    }
    
    func phoneVerificationApiCalled() {
        
//        Utils.showSpinner()
//
//        let countryCodeString = ((countryCode.replacingOccurrences(of: "+", with: "")).replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: ""))
//
//        let verifyTye = comeFrom == .signup ? "signup" : "login"
//        let param = [kCountry_Code: countryCodeString, kPhone: phoneNumber.replacingOccurrences(of: "-", with: ""), kVerify_Type:   verifyTye] as [String: Any]
//        ServiceManager.shared.signInSingup(params: param) {
//            [weak self] (status, errorMessage) in
//            Utils.hideSpinner()
//            guard let self_ = self else { return }
//            if (status) {
//                self_.codeSentSuccess?()
//                self_.updateViewStage?(.start)
//            } else {
//                self_.showMessage?(errorMessage ?? "Please try again")
//            }
//        }
    }
    
}
