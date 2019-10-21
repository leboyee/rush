//
//  FriendsListViewController.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EventGoingFriendsViewController: UIViewController {
    
    @IBOutlet weak var firstSegmentButton: UIButton!
    @IBOutlet weak var secondSegmentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var topConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var segmentContainView: UIView!
    
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
    var pageNo = 1
    var isNextPageExist = false
    var inviteType: InviteType = .going
    var searchTextFiled: UITextField?
    var userInfo: User?
    var task: URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchInvitees(search: "", type: .going)
        fetchInvitees(search: "", type: .notGoing)
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack

        // Setup tableview
        setupTableView()
        selectedSegment(tag: 0)

           let customView = UIView(frame: CGRect(x: 48, y: 0, width: screenWidth - 48, height: 44))
            searchTextFiled = UITextField(frame: CGRect(x: 0, y: -3, width: screenWidth - 48, height: 44))
            searchTextFiled?.font = UIFont.displayBold(sz: 24)
            searchTextFiled?.textColor = UIColor.white
            searchTextFiled?.returnKeyType = .go
            searchTextFiled?.autocorrectionType = .no
            searchTextFiled?.delegate = self
            let font = UIFont.displayBold(sz: 24)
            let color = UIColor.navBarTitleWhite32
            let title = "Search attendees"
            searchTextFiled?.attributedPlaceholder = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
            searchTextFiled?.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
            customView.addSubview(searchTextFiled ?? UITextField())
            navigationItem.titleView = customView
            self.view.backgroundColor = UIColor.bgBlack
        
        self.firstSegmentButton.setTitle("\(self.goingInviteeList.count) going", for: .normal)
        self.secondSegmentButton.setTitle("\(self.notGoingInviteeList.count) not going", for: .normal)

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
            fetchInvitees(search: "", type: .notGoing)
        } else {
            secondSegmentButton.setTitleColor(UIColor.buttonDisableTextColor, for: .normal)
            secondSegmentButton.backgroundColor = UIColor.white
            firstSegmentButton.setTitleColor(UIColor.white, for: .normal)
            firstSegmentButton.backgroundColor = UIColor.bgBlack
            firstSegmentButton.isSelected = true
            secondSegmentButton.isSelected = false
            inviteType = .going
            fetchInvitees(search: "", type: .going)
        }
        
        let leftbarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .done, target: self, action: #selector(backButtonAction))
        navigationItem.leftBarButtonItem = leftbarButton
    }
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Actions
extension EventGoingFriendsViewController {
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
extension EventGoingFriendsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.friendProfileSegue {
            if let vc = segue.destination as? OtherUserProfileController {
                vc.userInfo = sender as? User
                //vc.delegate = self
            }
        }
    }
}
