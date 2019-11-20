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
        connectSendbird()
    }
    
    func setupIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    // MARK: - Setup Google
    func setupGoogle() {
        GMSPlacesClient.provideAPIKey("AIzaSyCKPwD4WcX53pZRlh5RquAOWIPVZuTP9Fc")
    }
    
}

// MARK: - SendBird Chat SDK
extension AppDelegate: SBDChannelDelegate {
    
    func connectSendbird() {
        SBDMain.initWithApplicationId("586E0DEA-1868-4E61-9320-38CC32310696")
        SBDMain.add(self as SBDChannelDelegate, identifier: "AppDelegate")
        
        //Connect with Chat Server
        updateUserChatProfilePicture()
    }
    
    func disConnectSendbird() {
        ChatManager().disconnectFromChatServer()
    }
    
    func updateUserChatProfilePicture() {
        if let profile = Authorization.shared.profile {
            
            var name = profile.name
            if name.count > 80 {
                name = String(name.dropLast(name.count - 80))
            }
            ChatManager().connectToChatServer(userId: profile.userId, username: name, profileImageUrl: profile.photo?.thumb ?? "")
        }
    }
    
    func registerPushTokenWithSendBird() {
        if Authorization.shared.authorized && Authorization.shared.profile?.isNotifyOn == 1 {
            if (Utils.getDataFromUserDefault(kDeviceTokenPushDataKey)) != nil {
                if let data = Utils.getDataFromUserDefault(kDeviceTokenPushDataKey) as? Data {
                    
                    SBDMain.registerDevicePushToken(data, unique: true) { [weak self] (status, error) in
                        guard let unself = self else { return }
                        if error == nil {
                            if Int(status.rawValue) == 1 {
                                unself.isTokenRegistrationPending = true
                            } else {
                                // Registration succeeded.
                                unself.isTokenRegistrationPending = false
                            }
                        } else {
                            // Registration failed.
                            unself.isTokenRegistrationPending = true
                        }
                    }
                }
            }
        }
    }
    
    func unregisterPushTokenWithSendBird() {
        
        if Utils.getDataFromUserDefault(kDeviceTokenPushDataKey) != nil {
            if let data = Utils.getDataFromUserDefault(kDeviceTokenPushDataKey) as? Data {
                SBDMain.unregisterPushToken(data, completionHandler: { _, error in
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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUpdateUnreadcount), object: (count))
            Utils.saveDataToUserDefault(count, kUnreadChatMessageCount)
        }
    }
    
}
