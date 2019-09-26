//
//  PrivacySettingsViewController.swift
//  Rush
//
//  Created by kamal on 09/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

enum PrivacyType {
    case invitesfrom
    case messagefrom
}

class PrivacySettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var type: PrivacyType = .invitesfrom
    let list = ["Everyone", "Only friends", "Friends and their friends", "Nobody"]
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Setup
extension PrivacySettingsViewController {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
        
        let text = type == .invitesfrom ? Text.invitesFrom : Text.messagesFrom
        let customTitleView = Utils.getNavigationBarTitle(title: text, textColor: UIColor.white)
        navigationItem.titleView = customTitleView
        user = Authorization.shared.profile

        setupTableView()
    }
    
}
// MARK: - Presenter Funcation
extension PrivacySettingsViewController {
    
    func showMessage(message: String) {
        Utils.alert(message: message)
    }
}
