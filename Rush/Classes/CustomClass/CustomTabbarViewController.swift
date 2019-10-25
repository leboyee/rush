//
//  TabbarViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

let globalAppBgColor = UIColor.white
let tabbarItemTintColor = UIColor(red: 0.56, green: 0.24, blue: 0.33, alpha: 1)

class CustomTabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    static let shared = CustomTabbarViewController()
    
    var firstNavigationController: UINavigationController!
    var secondNavigationController: UINavigationController!
    var thirdNavigationController: UINavigationController!
    var fourthNavigationViewController: UINavigationController!
    //var fifthNavigationController: UINavigationController!
    
    let userImageName = "profile_tab_active"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTabbar()
        updateLoginUserPhotoOnLastTab()

    }
}

// MARK: - Other functions
extension CustomTabbarViewController {
    
    func setupUI() {
        
        tabBar.barTintColor = globalAppBgColor
        tabBar.tintColor = tabbarItemTintColor
        
        // First tab
        let fStory = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = fStory.instantiateInitialViewController()
        firstNavigationController = UINavigationController(rootViewController: homeViewController!)
        
        // Second tab
        let sStory = UIStoryboard(name: "Explore", bundle: nil)
        let exploreViewController = sStory.instantiateInitialViewController()
        secondNavigationController = UINavigationController(rootViewController: exploreViewController!)
        
        // Third tab
        let chatStory = UIStoryboard(name: "Chats", bundle: nil)
        let chatsViewController = chatStory.instantiateInitialViewController()
        thirdNavigationController = UINavigationController(rootViewController: chatsViewController!)
        
        /*
        // Fourth tab
        let tStory = UIStoryboard(name: "Forum", bundle: nil)
        let forumViewController = tStory.instantiateInitialViewController()
        fourthNavigationViewController = UINavigationController(rootViewController: forumViewController!)
        */
        
        // Fifth tab
        let profileStory = UIStoryboard(name: "Profile", bundle: nil)
        let profileViewController = profileStory.instantiateInitialViewController()
        fourthNavigationViewController = UINavigationController(rootViewController: profileViewController!)
        
        self.delegate = self
        setupIcons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateChatItem(_:)), name: NSNotification.Name(rawValue: kUpdateUnreadcount), object: nil)
    }
    
    /*
        Tab bar item select & unselect set images
        & add custom image for profile tab
    */
    
    func setupIcons() {
        
        firstNavigationController.tabBarItem.image = getImage("home_tab_inactive")
        firstNavigationController.tabBarItem.selectedImage =
            getImage("home_tab_active")
        
        secondNavigationController.tabBarItem.image = getImage("explore_tab_inactive")
        secondNavigationController.tabBarItem.selectedImage = getImage( "explore_tab_active")
        
        thirdNavigationController.tabBarItem.image = getImage("chat_tab_inactive")
        thirdNavigationController.tabBarItem.selectedImage = getImage( "chat_tab_active")
        
        let customTabBarItem = UITabBarItem(title: nil, image: getImage("profile_tab_inactive"), selectedImage: getImage("profile_tab_active"))
        fourthNavigationViewController.tabBarItem = customTabBarItem
        
    }
    
    @objc func updateChatItem(_ notification: Notification) {
        
        if let count = notification.object as? Int, count > 0 {
            tabBar.items?[2].badgeValue = ""
            tabBar.items?[2].badgeColor = UIColor.brown72
        } else {
            tabBar.items?[2].badgeColor = UIColor.clear
        }
    }

    /*
        Show login user photo on last tab
    */
    func updateLoginUserPhotoOnLastTab() {
        if let url = Authorization.shared.profile?.photo?.urlThumb() {
            if let imageData =  try? Data(contentsOf: url) {
                let img =  UIImage(data: imageData)?.roundedImageWithBorder(width: 24, borderWidth: 0, color: .clear)
                let selectedImg = UIImage(data: imageData)?.roundedImageWithBorder(width: 24, borderWidth: 2, color: UIColor.brown24)
                if let tabbarItem = tabBar.items?.last {
                    tabbarItem.image = img?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                    tabbarItem.selectedImage = selectedImg?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                }
            }
        }
        
    }
    
    /*
        Set all view controller to tabbar controllers
    */
    func setupTabbar() {
        
        viewControllers = [firstNavigationController, secondNavigationController, thirdNavigationController, fourthNavigationViewController]
        
        /*
        let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 23, height: 23))
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 11.5
        profileImageView.image = UIImage(named: userImageName)
        */
        
        for tabBarItem in tabBar.items! {
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        }
    }
    
    func refreshTab() {
        if let url = Authorization.shared.profile?.photo?.urlThumb() {
            if let imageData =  try? Data(contentsOf: url) {
                let img =  UIImage(data: imageData)?.roundedImageWithBorder(width: 24, borderWidth: 0, color: .clear)
                let selectedImg = UIImage(data: imageData)?.roundedImageWithBorder(width: 24, borderWidth: 2, color: UIColor.brown24)
                
                let customTabBarItem = UITabBarItem(title: nil, image: img, selectedImage: selectedImg)
                fourthNavigationViewController.tabBarItem = customTabBarItem
                
                let controllers = [firstNavigationController, secondNavigationController, thirdNavigationController, fourthNavigationViewController]
                setViewControllers(controllers as? [UIViewController], animated: true)
            }
        }
    }
    
    func getImage(_ img: String) -> UIImage? {
        return UIImage(named: img)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
}

// MARK: - Tabbar delegate
extension CustomTabbarViewController {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            if let navController = viewController as? UINavigationController {
                navController.popToRootViewController(animated: false)
            }
        }
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
