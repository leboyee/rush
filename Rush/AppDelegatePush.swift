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

extension AppDelegate : UNUserNotificationCenterDelegate {
    func setupPush() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if error == nil {
                print("Push registration success.");
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Push registration FAILED.");
            }
            
            //Get Access for Photo Permision
            DispatchQueue.main.async {
                self.getPHPhotoLibraryAccess()
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Push Token: " + deviceTokenString)
        
        let oldPushToken = Utils.getDataFromUserDefault(kPushToken) as? String ?? ""
        updateToken(deviceTokenString: deviceTokenString, oldPushToken: oldPushToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Push Fail:" + error.localizedDescription)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        
        if let userData = notification.request.content.userInfo as? [String : Any] {
           handlePushInActiveState(userInfo: userData)
        }
        completionHandler([.alert , .sound , . badge])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        
        let userData = response.notification.request.content.userInfo
        handlePush(userData as? [String : Any] ?? [String: Any]())
        completionHandler()
    }
    
    func handlePush(_ userInfo: [String: Any]) {
        if Authorization.shared.authorized {
            if UIApplication.shared.applicationState != .active {
                if let aps = userInfo["aps"] as? [String: Any], let _ = aps["type"] as? String {
                    
                    Utils.saveDataToUserDefault(true, kOpenFromPushNotification)
                    if let viewcontroller = window?.rootViewController as? UITabBarController {
                        let selectedNavigationController = viewcontroller.selectedViewController as? UINavigationController
                        //Check current tab is 2 and navigation controller has first view is NotificationListViewController, so we need to update list
                        if viewcontroller.selectedIndex == 2, let vc = selectedNavigationController?.viewControllers.first as? NotificationListViewController {
                            vc.presenter.loadList()
                        } else {
                            selectedNavigationController?.dismiss(animated: false, completion: nil)
                            selectedNavigationController?.popToRootViewController (animated: false)
                            viewcontroller.selectedIndex = 2
                        }
                    }
                }
            }
        }
    }
    
    func handlePushInActiveState(userInfo: [String: Any]) {
        if Authorization.shared.authorized {
            if let aps = userInfo["aps"] as? [String: Any], let _ = aps["type"] as? String {
                if let tabbar = window?.rootViewController as? UITabBarController {
                    //Check current tab is 2
                    if tabbar.selectedIndex == 2 {
                        let selectedNavigationController = tabbar.selectedViewController as? UINavigationController
                        //Navigation controller has first view is NotificationListViewController, so we need to update list
                        if let vc = selectedNavigationController?.viewControllers.first as? NotificationListViewController {
                            vc.presenter.loadList()
                        }
                    }
                }
            }
        }
    }
}


//MARK: - API's
extension AppDelegate {
    
    func updateToken(deviceTokenString  : String, oldPushToken : String) {
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
            ServiceManager.shared.updateBadgeCount(params: [Keys.alert_badge: "\(count)"]) { (status, errorMessage) in
                UIApplication.shared.applicationIconBadgeNumber = count
            }
        }
    }
    
    func getBadgeCount() {
        if Authorization.shared.authorized {
            ServiceManager.shared.getBadgeCount() { (data, errorMessage) in
                if let count = data?[Keys.alert_badge] as? Int {
                    UIApplication.shared.applicationIconBadgeNumber = count
                }
            }
        }
    }
}
