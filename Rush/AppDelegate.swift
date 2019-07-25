//
//  AppDelegate.swift
//  Rush
//
//  Created by iChirag on 06/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import SendBirdSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isTokenRegistrationPending = true
    var channel : SBDGroupChannel?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupAppearance()
        
        //Add Third Party SDK
        addThirdPartySDK()
        
       // setupStoryboard()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func setupAppearance() {
        setupTopBar()
        setupBarButton()
    }
    
    func setupTopBar() {
        let navigationBarAppearance = UINavigationBar.appearance()
        let pargraphStyle = NSMutableParagraphStyle()
        pargraphStyle.alignment = .center
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barTintColor = UIColor.bgBlack
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.Semibold(sz: 17.0), NSAttributedString.Key.paragraphStyle : pargraphStyle]
        navigationBarAppearance.isTranslucent = true
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.backgroundColor = UIColor.bgBlack
        navigationBarAppearance.setBackgroundImage(UIImage(), for: .default)
        
        //Back Button
        navigationBarAppearance.backIndicatorImage = #imageLiteral(resourceName: "back-arrow")
        navigationBarAppearance.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-arrow")
        
    }
    
    func setupBarButton() {
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        if #available(iOS 11, *) {
            barButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
            barButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .highlighted)
            barButtonItemAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1 * screenWidth, vertical: 0), for: .default)
            
        } else {
            barButtonItemAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -80), for: .default)
            
        }
    }
    
    func setupStoryboard() {
        
        let tabbarStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let tabbarVC = tabbarStoryboard.instantiateInitialViewController()
        self.window?.rootViewController = tabbarVC
    }
    
    //MARK: - AppDelegate Instance
    class func getInstance() -> AppDelegate {
        return UIApplication.shared.delegate! as! AppDelegate
    }


}

