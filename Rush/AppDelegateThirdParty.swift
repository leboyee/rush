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
import Firebase
import Fabric

extension AppDelegate {
    func addThirdPartySDK() {
        
        //KeyboardManager
        setupIQKeyboardManager()
        setupGoogle()
        connectSendbird()
        
        //Check Reachability
        connectReachability()
        
        /// Firebase
        FirebaseApp.configure()
        
        /// Fabric
        Fabric.sharedSDK().debug = true
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
    
    // MARK: - Reachability
    func connectReachability() {
        reachability?.whenReachable = { reachability in
            isNetworkAvailable = true
        }
        reachability?.whenUnreachable = { _ in
            isNetworkAvailable = false
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}

// MARK: - SendBird Chat SDK
extension AppDelegate: SBDChannelDelegate {
    
    func connectSendbird() {
        SBDMain.initWithApplicationId(sendbirdProduction)
        SBDMain.add(self as SBDChannelDelegate, identifier: "AppDelegate")
        
        //Connect with Chat Server
        updateUserChatProfilePicture()
        
        registerPushTokenWithSendBird()
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
        unregisterPushTokenWithSendBird { (_) in
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
        
    }
    
    func unregisterPushTokenWithSendBird(completion: ((Bool) -> Void)?) {
        
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
        
        SBDMain.unregisterAllPushToken(completionHandler: { (_, error) in
            if error != nil { // Error.
                print(error?.localizedDescription ?? "")
            }
            completion?(true)
            
        })
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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kRefreshChatList), object: nil)
            Utils.saveDataToUserDefault(count, kUnreadChatMessageCount)
        }
    }
    
}
