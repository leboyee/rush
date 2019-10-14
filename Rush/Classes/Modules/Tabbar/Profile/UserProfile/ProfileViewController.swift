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
    var interests: [Interest]?
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
    
    var imagePageNo: Int = 1
    var imageNextPageExist = false
    
    var notificationPageNo: Int = 1
    var notificationNextPageExist = false
    
    var friendPageNo: Int = 1
    var friendNextPageExist = false
    
    let downloadQueue = DispatchQueue(label: "com.messapps.profileImages")
    let downloadGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
//        navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

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
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        //navigationController?.isNavigationBarHidden = false
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
        header.set(url: profileDetail.profile?.photo?.url())
    }
    
    func showEditProfile() {
        performSegue(withIdentifier: Segues.editProfileSegue, sender: nil)
    }
    
    func showAllFriends() {
        performSegue(withIdentifier: Segues.userFriendListSegue, sender: self)
    }
    
    func showAllInterests() {
        performSegue(withIdentifier: Segues.userInterestSegue, sender: self)
        //Utils.notReadyAlert()
    }
    
    func showAllImages(with index: Int) {
        performSegue(withIdentifier: Segues.profileImageViewSegue, sender: self)
//        Utils.notReadyAlert()
    }
    
    func showFriend(user: User) {
        performSegue(withIdentifier: Segues.profileFriendProfile, sender: user)
    }
    
    func showEvent(event: Event) {
        performSegue(withIdentifier: Segues.notificationEventDetail, sender: event)
    }
    
    func showClub(club: Club) {
        performSegue(withIdentifier: Segues.notificationClubDetail, sender: club)
    }
    
    func showClass(classObject: Class) {
        performSegue(withIdentifier: Segues.notificationClassDetail, sender: classObject)
    }
    
    func showPost(post: Post, object: Any?) {
        performSegue(withIdentifier: Segues.notificationPostDetail, sender: (post, object))
    }
}

// MARK: - Navigations
extension ProfileViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.profileFriendProfile {
            let vc = segue.destination as? OtherUserProfileController
            vc?.userInfo = sender as? User
            vc?.delegate = self
        } else if segue.identifier == Segues.userFriendListSegue {
            let vc = segue.destination as? UserFriendsListViewController
            vc?.userId = Authorization.shared.profile?.userId ?? ""
        } else if segue.identifier == Segues.notificationEventDetail {
            let vc = segue.destination as? EventDetailViewController
            if let event = sender as? Event {
                vc?.event = event
                vc?.eventId = String(event.id)
            }
        } else if segue.identifier == Segues.notificationClubDetail {
            let vc = segue.destination as? ClubDetailViewController
            vc?.clubInfo = sender as? Club
        } else if segue.identifier == Segues.notificationPostDetail {
            let vc = segue.destination as? PostViewController
            if let (post, object) = sender as? (Post, Any?) {
                vc?.postInfo = post
                if let event = object as? Event {
                    vc?.eventInfo = event
                } else if let club = object as? Club {
                    vc?.clubInfo = club
                }
            }
        } else if segue.identifier == Segues.profileImageViewSegue {
            let vc = segue.destination as? ProfileTileViewController
            vc?.imageArray = profileDetail.images ?? [Image]()
        }
    }
}
