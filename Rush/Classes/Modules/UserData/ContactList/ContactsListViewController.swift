//
//  ContactsListViewController.swift
//  Rush
//
//  Created by ideveloper on 17/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

typealias ContactsPresenterItem = (key: String, contacts: [Contact])

protocol ContactsListProtocol: class {
    func selectedContacts(_ contacts: [Contact])
}

class ContactsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inviteButton: UIButton!
    
    var items = [ContactsPresenterItem]()
    var itemsDictionary = [String: [Contact]]()
    var selectedItem = [Contact]()
    var searchTextFiled: UITextField?
    var isSearch = false
    var searchItem = [ContactsPresenterItem]()
    weak var delegate: ContactsListProtocol?
    var countryCode: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
            setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false

        DispatchQueue.main.async {
            self.getContacts()
        }
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack
        setupTableView()
        setupNavigation()
        loadCountryJson()
        inviteButton.layer.cornerRadius = 8.0
        inviteButton.clipsToBounds = true
    }
    
}

// MARK: - Actions
extension ContactsListViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func inviteButtonAction() {
        if delegate != nil {
            navigationController?.popViewController(animated: true)
            DispatchQueue.main.async { [unowned self] () in
                self.delegate?.selectedContacts(self.selectedItem)
            }
        } else {
            contactInviteApi()
            //self.navigationController?.popViewController(animated: true)
        }
        
    }
}

// MARK: - Mediator
extension ContactsListViewController {
    func inviteButtonVisiable() {
        inviteButton.setTitle(selectedItem.count == 1 ? "Invite 1 contact" : "Invite \(selectedItem.count) contacts", for: .normal)
        inviteButton.isHidden = self.selectedItem.count > 0 ? false : true
    }
}
