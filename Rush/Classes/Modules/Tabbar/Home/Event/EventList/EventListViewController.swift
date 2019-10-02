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
    var isMyEvents = true
    var isShowJoinEvents = false
    var searchText = ""
    var pageNo = 1
    var eventList = [Event]()
    var eventCategory = [EventCategory]()

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
        
        // Set left bar button and title
        let customView = UIView(frame: CGRect(x: 48, y: 0, width: screenWidth - 48, height: 44))
            let searchTextField = UITextField(frame: CGRect(x: 0, y: -3, width: screenWidth - 48, height: 44))
            searchTextField.font = UIFont.displayBold(sz: 24)
            searchTextField.textColor = UIColor.white
            searchTextField.returnKeyType = .go
            searchTextField.autocorrectionType = .no
            searchTextField.delegate = self
            let font = UIFont.displayBold(sz: 24)
            let color = UIColor.navBarTitleWhite32
            searchTextField.attributedPlaceholder = NSAttributedString(string: "Search events", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
            searchTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
            customView.addSubview(searchTextField)
            navigationItem.titleView = customView
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
        
        if segue.identifier == Segues.searchEventViewSegue {
            guard let vc = segue.destination as? SearchEventViewController else { return }
        }
    }
}
