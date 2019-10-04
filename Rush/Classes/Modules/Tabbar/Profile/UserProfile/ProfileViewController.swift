//
//  ProfileViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

struct ProfileDetail {
    var profile: User?
    var images: [Image]?
    var friends: [Friend]?
    var interests: [Tag]?
    var notifications: [NotificationItem]?
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var header: ParallaxHeader!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    var profileDetail = ProfileDetail()
    var headerFullHeight: CGFloat = 344
    let headerSmallHeight: CGFloat = 170
    var isOtherUserProfile: Bool = false
    var notificationPageNo: Int = 1
    var notificationNextPageExist = false
    
    var imagePageNo: Int = 1
    var imageNextPageExist = false
    
    let downloadQueue = DispatchQueue(label: "com.messapps.profileImages")
    let downloadGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.isNavigationBarHidden = true
        title = ""
        
        /// Load All data of screen
        loadAllData()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadGroup.notify(queue: downloadQueue) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - Setup
extension ProfileViewController {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
        setupTableView()
        setupHeader()
       
        /// setup HeaderData
        setupHeaderData()
        setupView()
    }
}

// MARK: - Actions
extension ProfileViewController {

    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Other Functions
extension ProfileViewController {
    
    func setupView() {
        if isOtherUserProfile {
            backButton.isHidden = false
            settingsButton.isHidden = true
            header.enableEdit(isEnabled: false)
            header.cameraButton.isHidden = true
            //headerFullHeight = headerSmallHeight +
            //                   (AppDelegate.shared?.window?.safeAreaInsets.top ?? 0)
        } else {
            backButton.isHidden = true
            profileDetail.profile = Authorization.shared.profile
            header.cameraButton.isHidden = false
        }
    }
    
    func setupHeaderData() {
        let name = profileDetail.profile?.name ?? ""
        header.set(name: name)
        let university = (profileDetail.profile?.university ?? "").isEmpty ? "" : (profileDetail.profile?.university ?? "")
        header.set(university: university)
        header.set(url: profileDetail.profile?.photo?.urlLarge())
    }
    
    func showEditProfile() {
        Utils.notReadyAlert()
    }
    
    func showAllFriends() {
        Utils.notReadyAlert()
    }
    
    func showAllInterests() {
        Utils.notReadyAlert()
    }
    
    func showAllImages(with index: Int) {
        Utils.notReadyAlert()
    }
    
    func showFriend(user: Friend) {
        performSegue(withIdentifier: Segues.profileFriendProfile, sender: user)
    }
    
}

// MARK: - Navigations
extension ProfileViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.profileFriendProfile {
            let vc = segue.destination as? OtherUserProfileController
            vc?.userInfo = sender as? User
            vc?.delegate = self
        }
    }
}
