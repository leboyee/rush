//
//  ContactsListViewController.swift
//  Rush
//
//  Created by ideveloper on 17/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

typealias ContactsPresenterItem = (key: String, contacts: [Contact])

class ContactsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inviteButton: UIButton!

    
    var isFromRegister = false
    var items = [ContactsPresenterItem]()
    let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var itemsDictionary = [String: [Contact]]()
    var selectedItem = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
      
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack
        setupTableView()
        setupNavigation()
        getContacts()
        inviteButton.layer.cornerRadius = 8.0
        inviteButton.clipsToBounds = true

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - Actions
extension ContactsListViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func inviteButtonAction() {
        Utils.alert(message: "Api in development")
    }

}

// MARK: - Mediator
extension ContactsListViewController {

    func inviteButtonVisiable() {
        inviteButton.setTitle(selectedItem.count == 1 ? "Invite 1 contact" : "Invite \(selectedItem.count) contacts", for: .normal)
        inviteButton.isHidden = self.selectedItem.count > 0 ? false : true
    }
    
    
}
