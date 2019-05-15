//
//  HomeViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isShowTutorial = true
    var isShowJoinEvents = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
    }
}

// MARK: - Navigation

extension HomeViewController {
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }
     */
}
