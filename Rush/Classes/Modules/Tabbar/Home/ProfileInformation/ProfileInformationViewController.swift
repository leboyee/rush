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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    //MARk: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
    }
}

// MARK: - Navigation
extension ProfileInformationViewController {
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }
     */
}
