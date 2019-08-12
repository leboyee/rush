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
    var user: Profile?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user = Authorization.shared.profile
        tableView.reloadData()
    }
    
}

//MARK: - Setup
extension SettingsViewController {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
        
        let customTitleView = Utils.getNavigationBarTitle(title: Text.settings, textColor: UIColor.white)
        navigationItem.titleView = customTitleView
        
        let button = UIButton()
        button.setTitle(Text.logout, for: .normal)
        button.titleLabel?.font = UIFont.Semibold(sz: 13.0)
        button.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        let logout = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = logout
        setupTableView()
    }
    
}

//MARK: - Actions
extension SettingsViewController {
    
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

//MARK: - Other Functions
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
    
    func showInstagramDisconnect() {
        performSegue(withIdentifier: Segues.disconnectInstagram, sender: nil)
    }
    
    func showMessage(message: String) {
        Utils.alert(message: message)
    }
}

//MARK: - Navigation
extension SettingsViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.webViewFile {
            let vc = segue.destination as! WebViewFileViewController
            vc.type = sender as? WebFile ?? .policy
        } else if segue.identifier == Segues.privacySettings {
            let vc = segue.destination as! PrivacySettingsViewController
            vc.type = sender as? PrivacyType ?? .invitesfrom
        }
    }
}
