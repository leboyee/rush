//
//  EventListViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 13/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//


import UIKit
import IQKeyboardManagerSwift

class EventListViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isShowJoinEvents = false
    var searchText = ""
    var pageNo = 1
    var eventList = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = false
        getEventList(sortBy: .upcoming)
    }
    
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
        setupNavigation()
        definesPresentationContext = true
    }
    
    func setupNavigation() {
        self.view.backgroundColor = UIColor.bgBlack
        
 
    }
}

// MARK: - Actions
extension EventListViewController {


}

// MARK: - Mediator / Presenter Functions
extension EventListViewController {


}

// MARK: - Navigation
extension EventListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.homeEventDetail {
            guard let vc = segue.destination as? EventDetailViewController else { return }
            vc.eventId = (sender as? Event)?.id
            vc.event = sender as? Event
        }
    }
}
