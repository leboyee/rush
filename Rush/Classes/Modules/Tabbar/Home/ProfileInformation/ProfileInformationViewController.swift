//
//  ProfileInformationViewController.swift
//  Rush
//
//  Created by ideveloper on 04/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ProfileInformationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userInfo: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.bgBlack
        // Do any additional setup after loading the view.
        setup()
    }
    //MARk: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        // Setup tableview
        setupTableView()
        
        navigationController?.navigationBar.isTranslucent = false
        
        // Setup navigation title
        navigationItem.titleView = Utils.getNavigationBarTitle(title: userInfo?.name ?? "", textColor: UIColor.white)
        
        // back button
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(cancelButtonAction))
    }
}

// MARK: - Actions
extension ProfileInformationViewController {
    @IBAction func cancelButtonAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Navigation
extension ProfileInformationViewController {
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }
     */
}
