//
//  FriendsListViewController.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class FriendsListViewController: UIViewController {
    
    var type: UserProfileDetailType = .clubs
    @IBOutlet weak var firstSegmentButton: UIButton!
    @IBOutlet weak var secondSegmentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var topConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var segmentContainView: UIView!
    var exploreType: ExploreSearchType = .none
    var inviteeList = [Invitee]()
    var myClassesList = [ClassJoined]()
    var firstTabList = [Any]()
    var firstTabPageNo = 1
    var firstTabNextPageExist = false
    var secondTabList = [Any]()
    var secondTabPageNo = 1
    var secondTabNextPageExist = false
    var goingInviteeList = [Invitee]()
    var notGoingInviteeList = [Invitee]()
    var isFirstTime = false
    var eventId: Int64 = 0
    var userName = "Jessica"
    var pageNo = 1
    var isNextPageExist = false
    var isAttendace: Bool = false
    var inviteType: InviteType = .going
    var searchTextFiled: UITextField?
    var userInfo: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*if type == .events {
         if firstSegmentButton.isSelected && firstTabList.count == 0 {
         getAttendingEventList()
         } else if secondSegmentButton.isSelected && secondTabList.count == 0 {
         getManagedEventList()
         }
         } else  if type == .clubs {
         if firstSegmentButton.isSelected && firstTabList.count == 0 {
         getJoinedClubListAPI()
         } else if secondSegmentButton.isSelected && secondTabList.count == 0 {
         getManagedClubList()
         }
         } else  if type == .friends {
         if firstSegmentButton.isSelected && firstTabList.count == 0 {
         getFriendsListAPI()
         } else if secondSegmentButton.isSelected && secondTabList.count == 0 {
         getMutualFriendsListAPI()}
         } else  */
        if type == .classes {
            getMyJoinedClasses()
        }
    }
    
    func setupUI() {
        firstSegmentButton.isSelected = true
        secondSegmentButton.isSelected = false
                 
        self.view.backgroundColor = UIColor.bgBlack
        if type == .classes {
            topConstraintOfTableView.constant = 0
            segmentContainView.isHidden = true
        } else {
            selectedSegment(tag: 0)
        }
        // Setup tableview
        setupTableView()
        if type == .classes || type == .friends || type == .clubs || type == .events {
            // Set navigation title
            userName = userInfo?.firstName ?? "User"
            let titleName = type == .friends ? "\(userName)'s friends" : type == .events ? "\(userName)'s events" : type == .clubs ? "\(userName)'s clubs" : type == .classes ? "\(userName)'s classes" : ""
            navigationItem.titleView = Utils.getNavigationBarTitle(title: titleName, textColor: UIColor.navBarTitleWhite32)
        } else {
        
        // Set navigation title
       // let titleName = type == .friends ? "\(userName)'s friends" : type == .events ? "\(userName)'s events" : type == .clubs ? "\(userName)'s clubs" : type == .classes ? "\(userName)'s classes" : ""
        //navigationItem.titleView = Utils.getNavigationBarTitle(title: titleName, textColor: UIColor.navBarTitleWhite32)
        }
        
    }
    
    func selectedSegment(tag: Int) {
        if tag == 1 {
            secondSegmentButton.setTitleColor(UIColor.white, for: .normal)
            secondSegmentButton.backgroundColor = UIColor.bgBlack
            
            firstSegmentButton.setTitleColor(UIColor.buttonDisableTextColor, for: .normal)
            firstSegmentButton.backgroundColor = UIColor.white
            firstSegmentButton.isSelected = false
            secondSegmentButton.isSelected = true
            inviteType = .notGoing
        } else {
            secondSegmentButton.setTitleColor(UIColor.buttonDisableTextColor, for: .normal)
            secondSegmentButton.backgroundColor = UIColor.white
            
            firstSegmentButton.setTitleColor(UIColor.white, for: .normal)
            firstSegmentButton.backgroundColor = UIColor.bgBlack
            firstSegmentButton.isSelected = true
            secondSegmentButton.isSelected = false
            inviteType = .going
        }
        
        // Testind values for tester :)
        var firstTitle = ""
        var secondTitle = ""
        if type == .friends {
            firstTitle = "Friends"
            secondTitle = "Mutual"
            if firstSegmentButton.isSelected && firstTabList.count == 0 {
                getFriendsListAPI()
            } else if secondSegmentButton.isSelected && secondTabList.count == 0 {
                getMutualFriendsListAPI()
            }
        } else if type == .events {
            firstTitle = "Attending"
            secondTitle = "Managed"
            if firstSegmentButton.isSelected && firstTabList.count == 0 {
                getAttendingEventList()
            } else if secondSegmentButton.isSelected && secondTabList.count == 0 {
                getManagedEventList()
            }
        } else if type == .clubs {
            firstTitle = "Joined"
            secondTitle = "Managed"
            if firstSegmentButton.isSelected && firstTabList.count == 0 {
                getJoinedClubListAPI()
            } else if secondSegmentButton.isSelected && secondTabList.count == 0 {
                getManagedClubList()
            }
        } else if type == .classes {
            getMyJoinedClasses()
        }
        
        firstSegmentButton.setTitle(firstTitle, for: .normal)
        secondSegmentButton.setTitle(secondTitle, for: .normal)
        
        let leftbarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .done, target: self, action: #selector(backButtonAction))
        navigationItem.leftBarButtonItem = leftbarButton
    }
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Actions
extension FriendsListViewController {
    @IBAction func firstSegmentButtonAction() {
        if firstSegmentButton.isSelected {
            return
        }
        selectedSegment(tag: 0)
    }
    
    @IBAction func secondSegmentButtonAction() {
        if secondSegmentButton.isSelected {
            return
        }
        selectedSegment(tag: 1)
    }
}

// MARK: - Navigation
extension FriendsListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.friendProfileSegue {
            if let vc = segue.destination as? OtherUserProfileController {
                vc.userInfo = sender as? User
                //vc.delegate = self
            }
        } else if segue.identifier == Segues.eventDetailSegue {
            if let vc = segue.destination as? EventDetailViewController {
                if let event = sender as? Event {
                    vc.eventId = String(event.id)
                    vc.event = event
                }
            }
        } else if segue.identifier == Segues.classDetailSegue {
            guard let vc = segue.destination as? ClassDetailViewController else { return }
            let classjoined = sender as? ClassJoined
            vc.selectedGroup = classjoined?.classGroup
            vc.subclassInfo = classjoined?.classes
        } else if segue.identifier == Segues.clubDetailSegue {
            guard let vc = segue.destination as? ClubDetailViewController else { return }
            vc.clubInfo = sender as? Club
        } else if segue.identifier == Segues.otherUserProfile {
            let vc = segue.destination as? OtherUserProfileController
            let friend = sender as? Friend
            vc?.userInfo = friend?.user
            //        vc?.delegate = self
        }
    }
}
