//
//  CreateClubViewController.swift
//  Rush
//
//  Created by ideveloper on 20/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

protocol ClubDetailProtocol: class {
    func deleteClubSuccess(_ club: Club?)
}

class ClubDetailViewController: BaseTableViewController {
    
    @IBOutlet weak var backgroundView: RBackgoundView!
    @IBOutlet weak var heightConstraintOfHeader: NSLayoutConstraint!
    @IBOutlet weak var clubHeader: ClubHeader!

    weak var delegate: ClubDetailProtocol?
    
    var interestList = [String]()
    var peopleList = [String]()
    var clubPostList = [Post]()
    
    var clubImage: UIImage = #imageLiteral(resourceName: "bound-add-img")
    
    var isReadMore = false
    var joinedClub = false
    
    var clubInfo: Club?
    var isMyClub = false
    var isFromCreateClub = false
    var isCallAPI = true
    var isFromChatDetail = false
    
    let headerFullHeight: CGFloat = 367
    let headerSmallWithDateHeight: CGFloat = 182
    let headerSmallWithoutDateHeight: CGFloat = 114
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        // fetch club detail (Flag for come from create post = false otherwise true)
        if isCallAPI {
            getClubDetailAPI()
        } else {
            isCallAPI = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        if self.isMovingFromParent && isFromCreateClub {
            navigationController?.popViewController(animated: false)
        }
    }
    
    deinit {
              NotificationCenter.default.removeObserver(self, name: Notification.Name.userProfile, object: nil)
          }
    
    //MARk: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        
        // Check this club is created by me(logged in user)
        let clubOwnerId = clubInfo?.clubUId ?? "id"
        let userId = Authorization.shared.profile?.userId ?? ""
        if userId == clubOwnerId {
            joinedClub = true
        } else {
            let filter = clubInfo?.myClubInvite?.filter({ $0.userId == userId })
            if filter?.count ?? 0 > 0 {
                joinedClub = true
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(userProfile), name: Notification.Name.userProfile, object: nil)
        
        // setup tableview
        setupTableView()
    }
}

// MARK: - Actions
extension ClubDetailViewController {
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func shareButtonAction() {
        performSegue(withIdentifier: Segues.sharePostSegue, sender: SharePostType.club)
    }
    
    @objc func userProfile(notification: NSNotification) {
           if let user = notification.userInfo?["user"] as? User {
               self.performSegue(withIdentifier: Segues.otherUserProfile, sender: user)
           }
       }
}

// MARK: - Others
extension ClubDetailViewController {
    func showPostImages(post: Post, index: Int) {
        performSegue(withIdentifier: Segues.eventPostImages, sender: (post, index))
    }
}

// MARK: - Navigation
extension ClubDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.otherUserProfile {
            if let vc = segue.destination as? OtherUserProfileController {
                // image for test
                vc.clubImage = clubImage
                vc.userInfo = sender as? User
                vc.delegate = self
            }
        } else if segue.identifier == Segues.sharePostSegue {
            if let vc = segue.destination as? SharePostViewController {
                if let type = sender as? SharePostType {
                    if type == .club {
                        vc.type = .club
                        vc.object = clubInfo
                        vc.delegate = self
                    }
                } else {
                    vc.type = .post
                    vc.object = sender
                    vc.delegate = self
                }
            }
        } else if segue.identifier == Segues.createPost {
            guard let vc = segue.destination as? CreatePostViewController else { return }
            vc.clubInfo = clubInfo
            vc.delegate = self
        } else if segue.identifier == Segues.postSegue {
            if let vc = segue.destination as? PostViewController {
                vc.postInfo = sender as? Post
                vc.clubInfo = clubInfo
                vc.delegate = self
            }
        } else if segue.identifier == Segues.eventPostImages {
            if let vc = segue.destination as? UserProfileGalleryViewController {
                if let (post, index) = sender as? (Post, Int) {
                    vc.list = post.images ?? [Image]()
                    vc.user = post.user ?? User()
                    vc.currentIndex = index
                }
            }
        } else if segue.identifier == Segues.friendList {
            if let vc = segue.destination as? FriendsListViewController {
                vc.hidesBottomBarWhenPushed = false
                vc.inviteeList = clubInfo?.invitees ?? [Invitee]()
                vc.clubId = clubInfo?.clubId ?? "0"
                vc.type = sender as? UserProfileDetailType ?? .none
            }
        }
    }
}
