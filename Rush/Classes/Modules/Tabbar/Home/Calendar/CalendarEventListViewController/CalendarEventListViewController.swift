//
//  CalendarEventListViewController.swift
//  Rush
//
//  Created by kamal on 07/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CalendarEventListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let radius: CGFloat = 32.0
    var events: [Event]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}


extension CalendarEventListViewController {
    
    private func setup() {
        
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = radius
        setupTableView()
        
    }
    
}
