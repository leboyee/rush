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
    @IBOutlet weak var customPullSpinner: UIActivityIndicatorView!
    
    var profileDetail = ProfileDetail()
    var headerFullHeight: CGFloat = 344
    let headerSmallHeight: CGFloat = 170
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
                
        NotificationCenter.default.addObserver(self, selector: #selector(loadNotifications), name: Notification.Name(rawValue: kRefreshNotification), object: nil)
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
        backButton.isHidden = true
        profileDetail.profile = Authorization.shared.profile
        header.cameraButton.isHidden = false
    }
    
    func setupHeaderData() {
        let name = profileDetail.profile?.name ?? ""
        header.set(name: name)
        header.set(university: "")
        if let university = profileDetail.profile?.university?.last {
            header.set(university: university.universityName)
        }
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
    }
    
    func showAllImages(with index: Int) {
        performSegue(withIdentifier: Segues.profileImageViewSegue, sender: self)
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
    
    func showClass(classId: Int64, groupId: Int64) {
        performSegue(withIdentifier: Segues.notificationClassDetail, sender: (classId, groupId))
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
            vc?.user = profileDetail.profile ?? User()
            vc?.isFromOtherUserProfile = false
        } else if segue.identifier == Segues.notificationClassDetail {
            guard let vc = segue.destination as? ClassDetailViewController else { return }
            if let (classId, groupId) = sender as? (Int64, Int64) {
                vc.classId = String(classId)
                vc.groupId = String(groupId)
            }
        }
    }
}
