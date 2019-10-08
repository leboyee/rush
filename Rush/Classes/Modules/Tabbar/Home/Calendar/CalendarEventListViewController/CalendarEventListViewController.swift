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
    @IBOutlet weak var emptyView: UIView!

    let radius: CGFloat = 32.0
    var groups: [EventGroup]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Private and setup
extension CalendarEventListViewController {
    
    private func setup() {
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = radius
        setupTableView()
    }
    
}

// MARK: - Actions
extension CalendarEventListViewController {

    @IBAction func exploreEvents() {
        performSegue(withIdentifier: Segues.exploreEvents, sender: nil)
    }
    
}

// MARK: - Other functions
extension CalendarEventListViewController {

    func loadEvents(groups: [EventGroup]?) {
        guard groups != nil, (groups?.count ?? 0) > 0 else {
            emptyView.isHidden = false
            tableView.isHidden = true
            return
        }
        emptyView.isHidden = true
        tableView.isHidden = false
        self.groups = groups
        tableView.reloadData()
    }
    
}
