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
        
        let backbutton = UIButton()
        backbutton.setImage(UIImage(named: "back-arrow"), for: .normal)
        backbutton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        let text = type == .invitesfrom ? Text.invitesFrom : Text.messagesFrom
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        label.text = text
        label.font = UIFont.displayBold(sz: 24)
        label.textColor = UIColor.white
        
        let stackview = UIStackView.init(arrangedSubviews: [backbutton, label])
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 8
        let titleBarItem = UIBarButtonItem(customView: stackview)
        
        navigationItem.leftBarButtonItem = titleBarItem
        navigationItem.hidesBackButton = true
        
        user = Authorization.shared.profile
        setupTableView()
    }
    
}

// MARK: - Actions
extension PrivacySettingsViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - Presenter Funcation
extension PrivacySettingsViewController {
    
    func showMessage(message: String) {
        Utils.alert(message: message)
    }
}
