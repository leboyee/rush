//
//  CreateClubViewController.swift
//  Rush
//
//  Created by Chirag on 20/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

class ClassDetailViewController: UIViewController {
    
    //    @IBOutlet weak var topConstraintOfTableView: NSLayoutConstraint!
    
    var interestList = [String]()
    var peopleList = [String]()
    var classesPostList = [Post]()
    
    var clubImage: UIImage?
    
    var isShowMore = false
    var joinedClub = false
    var isFromChatDetail = false
    
    var classInfo: Class?
    var subclassInfo: SubClass?
    var selectedGroup: ClassGroup?
    
    var classId = "0"
    var groupId = "0"
    
    let headerFullHeight: CGFloat = 367
    let headerSmallWithDateHeight: CGFloat = 182
    let headerSmallWithoutDateHeight: CGFloat = 114
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: RBackgoundView!
    @IBOutlet weak var heightConstraintOfHeader: NSLayoutConstraint!
    @IBOutlet weak var clubHeader: ClubHeader!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        if classId == "0" && groupId == "0" {
            if subclassInfo?.myJoinedClass?.count ?? 0 > 0 {
                let joinedClass = subclassInfo?.myJoinedClass?[0]
                classId = joinedClass?.classId ?? "0"
                groupId = joinedClass?.groupId ?? "0"
            } else {
                classId = selectedGroup?.classId ?? "0"
                groupId = selectedGroup?.id ?? "0"
            }
        }
        if classId != "0" && groupId != "0" {
            getClassDetailAPI(classId: classId, groupId: groupId)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.userProfile, object: nil)
    }
    
    // MARK: - Other function
    func setup() {
        
        setupUI()
    }
    
    func setupUI() {
        
        // share button
        let share = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(shareButtonAction))
        navigationItem.rightBarButtonItem = share
        NotificationCenter.default.addObserver(self, selector: #selector(userProfile), name: Notification.Name.userProfile, object: nil)
        
        // setup tableview
        setupTableView()
        
        clubHeader.changePhotoButton.isHidden = true
        clubHeader.addPhotoButton.isHidden = true
    }
}

// MARK: - Actions
extension ClassDetailViewController {
    @IBAction func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Others
extension ClassDetailViewController {
    func showPostImages(post: Post, index: Int) {
        performSegue(withIdentifier: Segues.eventPostImages, sender: (post, index))
    }
}

// MARK: - Actions
extension ClassDetailViewController {
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func shareButtonAction() {
        performSegue(withIdentifier: Segues.sharePostSegue, sender: subclassInfo)
        //        performSegue(withIdentifier: Segues.sharePostSegue, sender: SharePostType.club)
    }
    
    @objc func userProfile(notification: NSNotification) {
        if let user = notification.userInfo?["user"] as? User {
            self.performSegue(withIdentifier: Segues.otherUserProfile, sender: user)
        }
    }
}
// MARK: - Navigation
extension ClassDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.otherUserProfile {
            if let vc = segue.destination as? OtherUserProfileController {
                if let user = sender as? User {
                    vc.userInfo = user
                }
                // image for test
                vc.clubImage = clubImage
                vc.delegate = self
            }
        } else if segue.identifier == Segues.sharePostSegue {
            if let vc = segue.destination as? SharePostViewController {
                if let send = sender as? SubClass {
                    vc.type = .classes
                    vc.object = send
                    vc.delegate = self
                } else {
                    vc.type = .post
                    vc.object = sender
                    vc.delegate = self
                }
            }
        } else if segue.identifier == Segues.createPost {
            if let vc = segue.destination as? CreatePostViewController {
                vc.subclassInfo = subclassInfo
                vc.delegate = self
            }
        } else if segue.identifier == Segues.postSegue {
            if let vc = segue.destination as? PostViewController {
                vc.postInfo = sender as? Post
                vc.subclassInfo = subclassInfo
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
                //                vc.inviteeList = subclassInfo?.ros ?? [Invitee]()
                vc.classId = selectedGroup?.classId ?? "0"
                vc.groupId = selectedGroup?.id ?? "0"
                vc.type = sender as? UserProfileDetailType ?? .none
            }
        }
    }
}
