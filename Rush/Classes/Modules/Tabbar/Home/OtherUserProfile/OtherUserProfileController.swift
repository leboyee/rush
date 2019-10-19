//
//  CreateClubViewController.swift
//  Rush
//
//  Created by ideveloper on 20/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

protocol OtherUserProfileProtocol: class {
    func unfriendUser(_ name: String)
}

class OtherUserProfileController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraintOfImageView: NSLayoutConstraint!
    @IBOutlet weak var topConstraintOfLabel: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var topConstraintOfTableView: NSLayoutConstraint!
    
    var isShowMessageButton = false
    var friendType: ManageButtonType = .addFriend
    weak var delegate: OtherUserProfileProtocol?
    var clubImage: UIImage?
    var userInfo: User?
    var searchText = ""
    var pageNo = 1
    var pageNoClass = 1
    var isNextPageClass = true
    var clubList = [Club]()
    var eventList = [Event]()
    var classList = [ClassJoined]()
    var imagesList = [Image]()
    var rsvpQuestion: [RSVPQuestion]?
    var rsvpAnswer: [RSVPAnswer]?
    var friendList = [Friend]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = false
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.isNavigationBarHidden = false
        getProfileAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.bgBlack
        navigationController?.navigationBar.barTintColor = UIColor.bgBlack
        navigationController?.navigationBar.isTranslucent = false
    }
    
    //MARk: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        
        topConstraintOfTableView.constant = -Utils.navigationHeigh
        
        // share button
        let share = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(shareButtonAction))
        navigationItem.rightBarButtonItem = share
        
        // back button
        let cancel = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(cancelButtonAction))
        navigationItem.leftBarButtonItem = cancel
        
        setupTableView()
    }
    
    func openFriendListController() {
        performSegue(withIdentifier: Segues.friendList, sender: nil)
    }
}

// MARK: - Actions
extension OtherUserProfileController {
    @IBAction func cancelButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func shareButtonAction() {
        performSegue(withIdentifier: Segues.sharePostSegue, sender: nil)
    }
}

// MARK: - Navigation
extension OtherUserProfileController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.notificationAlert {
            if let controller = segue.destination as? NotificationAlertViewController {
                if let message = sender as? String {
                    controller.toastMessage = message
                    controller.delegate = self
                }
            }
        } else if segue.identifier == Segues.friendList {
            if let vc = segue.destination as? FriendsListViewController {
                vc.hidesBottomBarWhenPushed = false
                vc.userInfo = userInfo
                vc.type = sender as? UserProfileDetailType ?? .none
            }
        } else if segue.identifier == Segues.sharePostSegue {
            if let vc = segue.destination as? SharePostViewController {
                vc.type = .profile
            }
        } else if segue.identifier == Segues.profileInformation {
            if let vc = segue.destination as? ProfileInformationViewController {
                vc.userInfo = userInfo
            }
        } else if segue.identifier == Segues.clubDetailSegue {
            guard let vc = segue.destination as? ClubDetailViewController else { return }
            vc.clubInfo = sender as? Club
        } else if segue.identifier == Segues.classDetailSegue {
            guard let vc = segue.destination as? ClassDetailViewController else { return }
          let classjoined = sender as? ClassJoined
            vc.selectedGroup = classjoined?.classGroup
            vc.subclassInfo = classjoined?.classes
        } else if segue.identifier == Segues.otherProfileEventDetail {
            guard let vc = segue.destination as? EventDetailViewController else { return }
            if let event = sender as? Event {
               vc.eventId = String(event.id)
               vc.event = event
            }
        } else if segue.identifier == Segues.userProfileGallerySegue {
            if let vc = segue.destination as? UserProfileGalleryViewController {
                vc.hidesBottomBarWhenPushed = true
                vc.list = imagesList
                vc.user = userInfo ?? User()
                vc.currentIndex = 1
            }
        }
    }
}
