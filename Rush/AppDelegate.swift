//
//  AppDelegate.swift
//  Rush
//
//  Created by iChirag on 06/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import SendBirdSDK
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var isTokenRegistrationPending = true
    var channel: SBDGroupChannel?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupAppearance()
        
        //Add Third Party SDK
        addThirdPartySDK()
        setupStoryboard()
        setupPush()
        //Add Observer For Force logout
        NotificationCenter.default.addObserver(self, selector: #selector(forceLogout), name: Notification.Name.badAccess, object: nil)
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        print("url", url)
        if url.absoluteString.contains("rushapp://fp?") {
            let tokenMailComponents = url.absoluteString.components(separatedBy: "tkn=")
            let tokenComponents = tokenMailComponents.last?.components(separatedBy: "&email=")
            guard let token = tokenComponents?.first else { return true }
            DispatchQueue.main.async {
                self.setRootOfNewPassword(token: token)
            }
        }
        return true
    }
    
    func setRootOfNewPassword(token: String) {
        if let viewController = self.getTopViewController() {
            let storyboardName = UIStoryboard(name: StoryBoard.authorize, bundle: nil)
            guard let controller = storyboardName.instantiateViewController(withIdentifier: "EnterPasswordViewConteroller") as? EnterPasswordViewConteroller else { return }
            controller.token = token
            controller.loginType = .restorePassword
            let navigationController: UINavigationController?
            if let navController = viewController as? UINavigationController {
                navigationController = navController
            } else {
                let customTabbar = viewController as? CustomTabbarViewController
                let selectedIndex =  customTabbar?.selectedIndex
                navigationController = customTabbar?.viewControllers?[selectedIndex ?? 0] as? UINavigationController
            }
            navigationController?.navigationBar.isHidden = false
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func getTopViewController() -> UIViewController? {
        var topViewController = UIApplication.shared.keyWindow?.rootViewController
        while topViewController?.presentedViewController != nil {
            topViewController = topViewController?.presentedViewController
        }
        return topViewController
    }
    
    func setupAppearance() {
        setupTopBar()
        setupBarButton()
        // photoLibraryPermissionCheck()
    }
    
    func setupTopBar() {
        let navigationBarAppearance = UINavigationBar.appearance()
        let pargraphStyle = NSMutableParagraphStyle()
        pargraphStyle.alignment = .center
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barTintColor = UIColor.bgBlack
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.semibold(sz: 17.0), NSAttributedString.Key.paragraphStyle: pargraphStyle]
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
        barButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        barButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .highlighted)
        barButtonItemAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1 * screenWidth, vertical: 0), for: .default)
    }
    
    // MARK: - AppDelegate Instance
    class var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    // MARK: - Force logout
    @objc func forceLogout() {
        DispatchQueue.main.async {
            Authorization.shared.signOut()
            self.setupStoryboard()
        }
    }
    
    func setupStoryboard() {
        let step = Authorization.shared.profile?.step
        if Authorization.shared.authorized == true && step == 3 {
            let tabbarStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let tabbarVC = tabbarStoryboard.instantiateInitialViewController()
            self.window?.rootViewController = tabbarVC
            self.window?.makeKeyAndVisible()
        } else {
            let tabbarStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabbarVC = tabbarStoryboard.instantiateInitialViewController()
            self.window?.rootViewController = tabbarVC
            self.window?.makeKeyAndVisible()
        }
        
        //ThemeManager.shared.loadTheme()
        
        /*let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let viewController = storyBoard.instantiateViewController(withIdentifier: storyboardString )
         self.window = UIWindow(frame: UIScreen.main.bounds)
         self.window?.rootViewController = viewController
         self.window?.makeKeyAndVisible()*/
        //ThemeManager.shared.loadTheme()
    }
    
    //Temporary used for Registraiont
    func moveToTabbarWithoutRegister() {
        let tabbarStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let tabbarVC = tabbarStoryboard.instantiateInitialViewController()
        self.window?.rootViewController = tabbarVC
    }
    
    func photoLibraryPermissionCheck() {
        Utils.authorizePhoto(completion: { [weak self] (status) in
            guard let unsafe = self else { return }
            if status == .alreadyAuthorized || status == .justAuthorized {
                //unsafe.cameraPermissionCheck()
            } else {
                if status != .justDenied {
                    //Utils.photoLibraryPermissionAlert()
                }
            }
            unsafe.cameraPermissionCheck()
        })
    }
    
    func cameraPermissionCheck() {
        Utils.authorizeVideo(completion: { (status) in
            if status == .alreadyAuthorized || status == .justAuthorized {
                //unsafe.openCameraOrLibrary()
            } else {
                if status != .justDenied {
                    //Utils.alertCameraAccessNeeded()
                }
            }
            //unsafe.locationPermission()
        })
    }
    
    func locationPermission() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == CLAuthorizationStatus.notDetermined {
            CLLocationManager().requestWhenInUseAuthorization()
        } else {
            if authorizationStatus == CLAuthorizationStatus.denied || authorizationStatus == CLAuthorizationStatus.restricted {
                Utils.locationPermissionAlert()
            }
        }
    }
}
