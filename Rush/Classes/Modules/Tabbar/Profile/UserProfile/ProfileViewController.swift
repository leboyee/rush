//
//  ProfileViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

struct ProfileDetail {
    var profile: Profile?
    var images: [Image]?
    var friends: [Friend]?
    var interests: [Tag]?
    var notifications: [Any]?
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
    var isOtherUserProfile: Bool {
        return profileDetail.profile?.userId == Authorization.shared.profile?.userId
    }
    var notificationPageNo: Int = 1
    var notificationNextPageExist = false
    
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
        
        //TODO: - Temp Data
        profileDetail.interests = [
            Tag(id: 01, text: "Games"),
            Tag(id: 03, text: "Technologies"),
            Tag(id: 04, text: "VR"),
            Tag(id: 05, text: "Development"),
            Tag(id: 06, text: "Swift")
        ]
        
        let f1 = Friend()
        f1.firstName = "John"
        f1.lastName = "Smith"
        f1.university = "Harvard University"
        f1.photo = Image(
            url: "https://www.liulishenshe.com/Simplify_admin/images/profile/profile1.jpg"
        )
        
        let f2 = Friend()
        f2.firstName = "Jame"
        f2.lastName = "Brown"
        f2.university = "Harvard University"
        f2.photo = Image(
            url: "https://www.liulishenshe.com/Simplify_admin/images/profile/profile4.jpg"
        )
        
        let f3 = Friend()
        f3.firstName = "Elizabeth"
        f3.lastName = "Miller"
        f3.university = "Harvard University"
        f3.photo = Image(
            url: "https://www.liulishenshe.com/Simplify_admin/images/profile/profile7.jpg"
        )
        
        let f4 = Friend()
        f4.firstName = "Sarah"
        f4.lastName = "Jones"
        f4.university = "Harvard University"
        f4.photo = Image(
            url: "https://www.liulishenshe.com/Simplify_admin/images/profile/profile5.jpg"
        )
        
        let f5 = Friend()
        f5.firstName = "Karen"
        f5.lastName = "Jensen"
        f5.university = "Harvard University"
        f5.photo = Image(
            url: "https://www.liulishenshe.com/Simplify_admin/images/profile/profile3.jpg"
        )
        
        profileDetail.friends = [f1, f2, f3, f4, f5]
        /// End Temp Data
        
        setupTableView()
        setupHeader()
       
        /// setup HeaderData
        setupHeaderData()
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
    
    func setupHeaderData() {
        let name = profileDetail.profile?.name ?? ""
        header.set(name: name)
        let university = (profileDetail.profile?.university ?? "").isEmpty ?
                         "Harvard University" :
                         (profileDetail.profile?.university ?? "")
        header.set(university: university)
        header.set(url: profileDetail.profile?.photo?.url())
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
            let vc = segue.destination as? ProfileViewController
            vc?.profileDetail.profile = sender as? Profile
        }
    }
}
