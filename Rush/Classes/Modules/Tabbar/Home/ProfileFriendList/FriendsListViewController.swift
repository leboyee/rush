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
    var eventId: Int64 = 0
    var userName = "Jessica"
    var pageNo = 1
    var isNextPageExist = false
    var isAttendace: Bool = false
    var inviteType: InviteType = .going
    var searchTextFiled: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack
        if type == .classes {
            topConstraintOfTableView.constant = 0
            segmentContainView.isHidden = true
        } else {
            selectedSegment(tag: 0)
        }
        // Setup tableview
        setupTableView()
        
        // Set navigation title
        let titleName = type == .friends ? "\(userName)'s friends" : type == .events ? "\(userName)'s events" : type == .clubs ? "\(userName)'s clubs" : type == .classes ? "\(userName)'s classes" : ""
        //navigationItem.titleView = Utils.getNavigationBarTitle(title: titleName, textColor: UIColor.navBarTitleWhite32)
        
        if exploreType == .event {
            fetchInvitees(search: "")
        }
        
        let customView = UIView(frame: CGRect(x: 48, y: 0, width: screenWidth - 48, height: 44))
            searchTextFiled = UITextField(frame: CGRect(x: 0, y: -3, width: screenWidth - 48, height: 44))
            searchTextFiled?.font = UIFont.displayBold(sz: 24)
            searchTextFiled?.textColor = UIColor.white
            searchTextFiled?.returnKeyType = .go
            searchTextFiled?.autocorrectionType = .no
            searchTextFiled?.delegate = self
            let font = UIFont.displayBold(sz: 24)
            let color = UIColor.navBarTitleWhite32
            searchTextFiled?.attributedPlaceholder = NSAttributedString(string: "Search attendees", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
            searchTextFiled?.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        customView.addSubview(searchTextFiled ?? UITextField())
            navigationItem.titleView = customView
            self.view.backgroundColor = UIColor.bgBlack

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
            firstTitle = "122 friends"
            secondTitle = "20 mutual"
        } else if type == .events {
            firstTitle = "4 attending"
            secondTitle = "3 managed"
        } else if type == .clubs {
            firstTitle = "3 joined"
            secondTitle = "0 managed"
        }
               
        if exploreType == .event {
            firstTitle = "0 going"
            secondTitle = "0 not going"
            pageNo = 1
            fetchInvitees(search: searchTextFiled?.text ?? "")
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
        }
     }
}

