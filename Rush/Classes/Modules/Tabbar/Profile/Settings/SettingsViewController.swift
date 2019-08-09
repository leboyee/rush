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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
}

//MARK: - Setup
extension SettingsViewController {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
        
        let customTitleView = Utils.getNavigationBarTitle(title: Text.settings, textColor: UIColor.white)
        navigationItem.titleView = customTitleView
        
        
        let logout = UIBarButtonItem(title: Text.logout, style: .done, target: self, action: #selector(logoutAction))
        navigationItem.rightBarButtonItem = logout
        
        setupTableView()
    }
    
}

//MARK: - Actions
extension SettingsViewController {
    
    @objc func logoutAction() {
        Utils.notReadyAlert()
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
