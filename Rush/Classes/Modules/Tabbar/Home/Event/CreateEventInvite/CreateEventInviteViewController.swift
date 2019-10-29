//
//  ContactsListViewController.swift
//  Rush
//
//  Created by ideveloper on 17/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

protocol EventInviteDelegate: class {
    func selectedInvities(_ invite: [Invite])
}

class CreateEventInviteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inviteButton: UIButton!
    
    var items = [ContactsPresenterItem]()
    var itemsDictionary = [String: [Contact]]()
    var selectedItem = [Contact]()
    var friendListAraay = [Friend]()
    var selectedFriendListArray = [Friend]()
    var pageNo = 1
    var isNextPageExist = false
    var searchText = ""
    var friendsList = [String: Any]()
    var isRushFriends: Bool = false
    var selectedInvitee = [Invite]()
    var isSearch = false
    var searchItem = [ContactsPresenterItem]()
    weak var delegate: EventInviteDelegate?
    var searchTextFiled: UITextField?
    var isFirstTimeOnly = false
    var task: URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()
            setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.getFriendListAPI()
        }
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack
        setupTableView()
        setupNavigation()
        inviteButton.layer.cornerRadius = 8.0
        inviteButton.clipsToBounds = true
    }
    
}

// MARK: - Actions
extension CreateEventInviteViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func inviteButtonAction() {
        if delegate != nil {
            navigationController?.popViewController(animated: true)
            DispatchQueue.main.async { [unowned self] () in
                var inviteArray = [Invite]()
                for profile in self.selectedFriendListArray {
                    let invite = Invite()
                    invite.isFriend = true
                    invite.profile = profile.user
                    inviteArray.append(invite)
                }
                for contact in self.selectedItem {
                    let invite = Invite()
                    invite.isFriend = false
                    invite.contact = contact
                    inviteArray.append(invite)
                }
                self.delegate?.selectedInvities(inviteArray)
            }
        } else {
           // Utils.alert(message: "In development")
        }
    }
}

// MARK: - Mediator
extension CreateEventInviteViewController {
    func inviteButtonVisiable() {
        let count = selectedItem.count + selectedFriendListArray.count
        inviteButton.setTitle(count == 1 ? "Invite 1 contact" : "Invite \(count) contacts", for: .normal)
        inviteButton.isHidden = count > 0 ? false : true
    }
}
