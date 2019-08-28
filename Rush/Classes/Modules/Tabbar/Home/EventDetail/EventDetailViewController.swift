//
//  EventDetailViewController.swift
//  Rush
//
//  Created by kamal on 27/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension EventDetailViewController {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
    }
    
}
