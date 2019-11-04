//
//  SettingsViewController.swift
//  Rush
//
//  Created by kamal on 08/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        loadSettings()
    }
    
}

// MARK: - Setup
extension SettingsViewController {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
        tabBarController?.tabBar.isHidden = true

        let backbutton = UIButton()
        backbutton.setImage(UIImage(named: "back-arrow"), for: .normal)
        backbutton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        label.text = Text.settings
        label.font = UIFont.displayBold(sz: 24)
        label.textColor = UIColor.white
        
        let stackview = UIStackView.init(arrangedSubviews: [backbutton, label])
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 8
        let titleBarItem = UIBarButtonItem(customView: stackview)
        
        navigationItem.leftBarButtonItem = titleBarItem
        navigationItem.hidesBackButton = true

        let button = UIButton()
        button.setTitle(Text.logout, for: .normal)
        button.titleLabel?.font = UIFont.semibold(sz: 13.0)
        button.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        let logout = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = logout
        setupTableView()
    }
}

// MARK: - Actions
extension SettingsViewController {
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc func logoutAction() {
        performSegue(withIdentifier: Segues.logoutPopup, sender: nil)
    }
    
    @IBAction func policyButtonAction() {
        performSegue(withIdentifier: Segues.webViewFile, sender: WebFile.policy)
    }
    
    @IBAction func termsButtonAction() {
        performSegue(withIdentifier: Segues.webViewFile, sender: WebFile.term)
    }
}

// MARK: - Other Functions
extension SettingsViewController {

    func showPrivacyInvite() {
        performSegue(withIdentifier: Segues.privacySettings, sender: PrivacyType.invitesfrom)

    }
    
    func showPrivacyMessage() {
        performSegue(withIdentifier: Segues.privacySettings, sender: PrivacyType.messagefrom)
    }
   
    func showNotifications() {
        performSegue(withIdentifier: Segues.notificationSettings, sender: nil)
    }
    
    func showInstagramConnect() {
        performSegue(withIdentifier: Segues.settingsInstagramConnect, sender: nil)
    }
    
    func showInstagramDisconnect() {
        performSegue(withIdentifier: Segues.disconnectInstagram, sender: nil)
    }
    
    func showMessage(message: String) {
        Utils.alert(message: message)
    }
    
    func loadSettings() {
        user = Authorization.shared.profile
        tableView.reloadData()
    }
}

// MARK: - Navigation
extension SettingsViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.webViewFile {
            let vc = segue.destination as? WebViewFileViewController
            vc?.type = sender as? WebFile ?? .policy
        } else if segue.identifier == Segues.privacySettings {
            let vc = segue.destination as? PrivacySettingsViewController
            vc?.type = sender as? PrivacyType ?? .invitesfrom
        } else if segue.identifier == Segues.disconnectInstagram {
            let vc = segue.destination as? DisconnectInstagramViewController
            vc?.delegate = self
        } else if segue.identifier == Segues.changePasswordSegue {
            let vc = segue.destination as? EnterPasswordViewConteroller
            vc?.hidesBottomBarWhenPushed = true
            vc?.loginType = .changePassword
        }
    }
}
