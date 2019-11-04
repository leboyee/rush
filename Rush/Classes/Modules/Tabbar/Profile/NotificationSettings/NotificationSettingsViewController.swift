//
//  NotificationSettingsViewController.swift
//  Rush
//
//  Created by kamal on 09/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class NotificationSettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let list = ["Events", "Clubs", "Classes"]
    var selectedIndex: [Int] = []
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Setup
extension NotificationSettingsViewController {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
                
        let backbutton = UIButton()
        backbutton.setImage(UIImage(named: "back-arrow"), for: .normal)
        backbutton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        label.text = Text.notifications
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
extension NotificationSettingsViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - Presenter Funcation
extension NotificationSettingsViewController {

    func showMessage(message: String) {
        Utils.alert(message: message)
    }
}
