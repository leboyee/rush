//
//  AppDelegateThirdParty.swift
//  Rush
//
//  Created by iChirag on 06/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SendBirdSDK
import GooglePlaces

extension AppDelegate {
    func addThirdPartySDK() {
        
        //KeyboardManager
        setupIQKeyboardManager()
        setupGoogle()
    }
    
    func setupIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    // MARK: - Setup Google
    func setupGoogle() {
        GMSPlacesClient.provideAPIKey("AIzaSyBa9T2HvCONOPsh73oB3AvCu0UDKOH8REM")
    }
    
}

//MARK:- SendBird Chat SDK
extension AppDelegate : SBDChannelDelegate {
    
    func connectSendbird() {
        SBDMain.initWithApplicationId("834DA8CF-7324-450C-96EC-")
        SBDMain.add(self as SBDChannelDelegate, identifier: "AppDelegate")
        
        //Connect with Chat Server
        if let profile = Authorization.shared.profile {
            ChatManager().connectToChatServer(userId: profile.userId, username: profile.name, profileImageUrl: profile.photo?.thumb ?? "")
        }
    }
    
    func registerPushTokenWithSendBird() {
        if Authorization.shared.authorized && (Authorization.shared.profile?.isNotificationOn ?? false) {
            if ((Utils.getDataFromUserDefault(kDeviceTokenPushDataKey)) != nil) {
                if let data = Utils.getDataFromUserDefault(kDeviceTokenPushDataKey) as? Data {
                    
                    SBDMain.registerDevicePushToken(data, unique: true) {
                        [weak self] (status, error) in
                        guard let self_ = self else { return }
                        if error == nil {
                            if Int(status.rawValue) == 1 {
                                self_.isTokenRegistrationPending = true
                            } else {
                                // Registration succeeded.
                                self_.isTokenRegistrationPending = false
                            }
                        } else {
                            // Registration failed.
                            self_.isTokenRegistrationPending = true
                        }
                    }
                }
            }
        }
    }
    
    func unregisterPushTokenWithSendBird() {
        
        if (Utils.getDataFromUserDefault(kDeviceTokenPushDataKey) != nil) {
            if let data = Utils.getDataFromUserDefault(kDeviceTokenPushDataKey) as? Data {
                SBDMain.unregisterPushToken(data, completionHandler: { response, error in
                    if error == nil {
                        print("unregisterPushToken successfully")
                    } else {
                        print("unregisterPushToken failed")
                    }
                })
            }
        }
    }
    
    
    
    // MARK: - Chat SDK
    
    func moveOnMessageScreen(channelUrl: String?) {
        
        if let viewcontroller = window?.rootViewController as? CustomTabbarViewController {
            let selectedNavigationController = viewcontroller.selectedViewController as? UINavigationController
            selectedNavigationController?.dismiss(animated: false, completion: nil)
            
            /*
            if viewcontroller.selectedIndex == 0 {
                if let vc = selectedNavigationController?.viewControllers.first as? MatchViewController {
                    let isPush = (selectedNavigationController?.viewControllers.count ?? 0) == 1 ? false : true
                    if isPush {
                        selectedNavigationController?.popToRootViewController (animated: false)
                    } else {
                        vc.presenter.chatManager()
                    }
                }
                
            } else {
                selectedNavigationController?.popToRootViewController (animated: false)
                viewcontroller.matchButtonAction()
            }
            */
        }
        
        /*
         ChatManager().getChannelWithChannelUrl(channelUrl, completionHandler: { (channel) in
         
         self.channel = channel
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
         let navigationController =  AppNavigator.shared.getTopViewController() as? CustomTabbarViewController
         
         navigationController?.matchButtonAction()
         
         
         })
         }) { (error) in
         if error != nil {
         print(error!)
         }
         }
         */
    }
    
    func moveOnScreenForNotification(_ isLongTermMemoryNotification: Bool) {
        
    }
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        ChatManager().getUnreadCount { (count) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:kUpdateUnreadcount), object: (count))
        }
    }
    
}
