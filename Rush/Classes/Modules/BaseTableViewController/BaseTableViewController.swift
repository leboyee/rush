//
//  BaseTableViewController.swift
//  Rush
//
//  Created by kamal on 29/11/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class BaseTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (view.frame.size.height + view.frame.origin.y) == screenHeight {
            let adjustForTabbarInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
            tableView.contentInset = adjustForTabbarInsets
            tableView.scrollIndicatorInsets = adjustForTabbarInsets
        }
    }
}
