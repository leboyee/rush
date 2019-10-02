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
    var friendType: ManageButtonType = .friends
    
    weak var delegate: OtherUserProfileProtocol?
    
    var clubImage: UIImage?
    var userInfo: User?
    
    var searchText = ""
    var pageNo = 1
    var clubList = [Club]()
    var eventList = [Event]()
    var classList = [Class]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = false
        getProfileAPI()
        getClubListAPI(sortBy: "feed")
        getEventList(sortBy: .upcoming)
        getClassCategoryAPI()
    }
    
    //MARk: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        /*
         scrollView.delegate = self
         
         tableView.layer.cornerRadius = 24
         tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
         
         let total = (screenWidth * 0.85) + Utils.navigationHeigh + 18
         heightConstraintOfImageView.constant = total
         
         scrollView.contentInset = UIEdgeInsets(top: (total * 0.5223), left: 0, bottom: 0, right: 0)
         //        topConstraintOfScrollViw.constant = (total * 0.5223) + Utils.navigationHeigh + 18
         
         topConstraintOfLabel.constant = (total * 0.6)
         */
        
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
            vc.classInfo = sender as? Class
        } else if segue.identifier == Segues.otherProfileEventDetail {
            guard let vc = segue.destination as? EventDetailViewController else { return }
            vc.eventId = (sender as? Event)?.id
            vc.event = sender as? Event
        }
    }
}
