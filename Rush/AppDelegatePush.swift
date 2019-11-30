//
//  AppDelegatePush.swift
//  PaidMeals
//
//  Created by Suresh Jagnani on 09/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    func setupPush() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { ( _, error) in
            if error == nil {
                print("Push registration success.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Push registration FAILED.")
            }
            self.photoLibraryPermissionCheck()
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
        print("Push Token: " + deviceTokenString)
        
        let oldPushToken = Utils.getDataFromUserDefault(kPushToken) as? String ?? ""
        updateToken(deviceTokenString: deviceTokenString, oldPushToken: oldPushToken)
        Utils.saveDataToUserDefault(deviceToken, kDeviceTokenPushDataKey)
        
        registerPushTokenWithSendBird()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Push Fail:" + error.localizedDescription)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        
        if let userData = notification.request.content.userInfo as? [String: Any] {
            handlePushInActiveState(userInfo: userData)
        }
        completionHandler([.alert, .sound, . badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        let userData = response.notification.request.content.userInfo
        handlePush(userData as? [String: Any] ?? [String: Any]())
        completionHandler()
    }
    
    func handlePush(_ userInfo: [String: Any]) {
        if Authorization.shared.authorized {
            if UIApplication.shared.applicationState != .active {
                if let data = userInfo["sendbird"] as? [String: Any] {
                    //Show Message Screen
                    if let channel = data["channel"] as? [String: Any] {
                        if let url = channel["channel_url"] as? String {
                            print("Chat channel url: \(url)")
                            Utils.saveDataToUserDefault(true, kOpenFromPushNotification)
                            if let viewcontroller = window?.rootViewController as? UITabBarController {
                                let selectedNavigationController = viewcontroller.selectedViewController as? UINavigationController
                                //Check current tab is 2 and navigation controller has first view is NotificationListViewController, so we need to update list
                                if viewcontroller.selectedIndex == 2, let vc = selectedNavigationController?.viewControllers.first as? ChatsViewController {
                                    vc.getListOfGroups(isFromPush: true, url: url)
                                } else {
                                    selectedNavigationController?.dismiss(animated: false, completion: nil)
                                    selectedNavigationController?.popToRootViewController(animated: false)
                                    viewcontroller.selectedIndex = 2
                                    let newSelectedNavigationController = viewcontroller.selectedViewController as? UINavigationController
                                    let vc = newSelectedNavigationController?.viewControllers.first as? ChatsViewController
                                    vc?.getListOfGroups(isFromPush: true, url: url)
                                }
                            }
                            
                        }
                    }
                } else /*if let aps = userInfo["aps"] as? [String: Any], let type = aps["type"] as? String*/ {
                    //print(type)
                    if let viewcontroller = window?.rootViewController as? UITabBarController {
                        let selectedNavigationController = viewcontroller.selectedViewController as? UINavigationController
                            selectedNavigationController?.dismiss(animated: false, completion: nil)
                            selectedNavigationController?.popToRootViewController(animated: false)
                            viewcontroller.selectedIndex = 3
                        
                        if UIApplication.shared.applicationIconBadgeNumber > 0 {
                            updateBadgeCount(count: UIApplication.shared.applicationIconBadgeNumber - 1)
                        }
                    }
                }
            }
        }
    }
    
    func handlePushInActiveState(userInfo: [String: Any]) {
        if Authorization.shared.authorized {
            if let aps = userInfo["aps"] as? [String: Any], let type = aps["type"] as? String {
                print(type)
                //               if let tabbar = window?.rootViewController as? UITabBarController {
                //
                //               }
            }
        }
    }
}

// MARK: - API's
extension AppDelegate {
    
    func updateToken(deviceTokenString: String, oldPushToken: String) {
        //Update New Token in local
        Utils.saveDataToUserDefault(deviceTokenString, kPushToken)
        if Authorization.shared.authorized {
            //Update token of user if token is changed.
            if Utils.getDataFromUserDefault(kPushTokenUpdateOnServer) == nil || oldPushToken != deviceTokenString {
                //API call and when success
                ServiceManager.shared.updatePushToken(closer: { (status, _) in
                    if status {
                        Utils.saveDataToUserDefault(deviceTokenString, kPushTokenUpdateOnServer)
                    }
                })
            }
        }
    }
    
    func updateBadgeCount(count: Int) {
        if Authorization.shared.authorized {
            ServiceManager.shared.updateBadgeCount(params: [Keys.alertBadge: "\(count)"]) { (_, _) in
                UIApplication.shared.applicationIconBadgeNumber = count
            }
        }
    }
    
    func getBadgeCount() {
        if Authorization.shared.authorized {
            ServiceManager.shared.getBadgeCount { (data, _) in
                if let count = data?[Keys.alertBadge] as? Int {
                    UIApplication.shared.applicationIconBadgeNumber = count
                }
            }
        }
    }
}
