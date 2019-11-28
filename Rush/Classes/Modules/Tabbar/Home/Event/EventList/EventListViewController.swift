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
    @IBOutlet weak var noEventsView: UIView!
    
    var isMyEvents = false
    var isShowJoinEvents = false
    var isNextPageEvent = false
    var isNextPageMyEvent = false
    var searchText = ""
    var pageNo = 1
    var myEventPageNo = 1
    var eventList = [Event]()
    var searchTextFiled: UITextField?
    var eventCategory = [Interest]()
    var eventFilterType: GetEventType = .myUpcoming
    var isFirstTime = false
    var isApiCalling = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.bgBlack
        navigationController?.navigationBar.barTintColor = UIColor.bgBlack
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = false
        myEventPageNo = 1
        if let filter = Utils.getDataFromUserDefault(UserDefaultKey.myUpcomingFilter) as? String {
            eventFilterType = filter == "All Upcoming" ? .myUpcoming : .managedFirst
            getMyEventList(sortBy: eventFilterType)
        } else {
            getMyEventList(sortBy: eventFilterType)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchTextFiled?.resignFirstResponder()
        navigationController?.navigationBar.backgroundColor = UIColor.bgBlack
        navigationController?.navigationBar.barTintColor = UIColor.bgBlack
        
    }
    
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
        setupNavigation()
        self.noEventsView.isHidden = true
        definesPresentationContext = true
    }
    
    func setupNavigation() {
        
        // Set left bar button and title
        let customView = UIView(frame: CGRect(x: 48, y: 0, width: screenWidth - 48, height: 44))
        searchTextFiled = UITextField(frame: CGRect(x: 0, y: -3, width: screenWidth - 48, height: 44))
        searchTextFiled?.font = UIFont.displayBold(sz: 24)
        searchTextFiled?.textColor = UIColor.white
        searchTextFiled?.returnKeyType = .go
        searchTextFiled?.autocorrectionType = .no
        searchTextFiled?.delegate = self
        let font = UIFont.displayBold(sz: 24)
        let color = UIColor.navBarTitleWhite32
        searchTextFiled?.attributedPlaceholder = NSAttributedString(string: "Search events", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
        searchTextFiled?.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        customView.addSubview(searchTextFiled ?? UITextField())
        navigationItem.titleView = customView
        self.view.backgroundColor = UIColor.bgBlack
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus_white"), style: .plain, target: self, action: #selector(plusButtonAction))
    }
    
    func showMessage(message: String) {
        Utils.alert(message: message)
    }
    
}

// MARK: - Actions
extension EventListViewController {
    @objc func plusButtonAction() {
        // Utils.alert(message: "In Development")
    }
}
// MARK: - Mediator / Presenter Functions
extension EventListViewController {
    func showEvent(event: Event?) {
        performSegue(withIdentifier: Segues.eventListToEventDetailsSegue, sender: event)
    }
    
    func showRSVP(event: Event) {
        performSegue(withIdentifier: Segues.rsvpJoinEvent, sender: event)
    }
    
    func showJoinAlert() {
        performSegue(withIdentifier: Segues.eventWithoutRSVPJoinedPopup, sender: nil)
    }
    
}
// MARK: - Navigation
extension EventListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.eventListToEventDetailsSegue {
            guard let vc = segue.destination as? EventDetailViewController else { return }
            if let event = sender as? Event {
                vc.eventId = String(event.id)
                vc.event = event
            }
        } else if segue.identifier == Segues.rsvpJoinEvent {
            if let vc = segue.destination as? RSVPViewController {
                if let event = sender as? Event {
                    vc.event = event
                    vc.action = EventAction.join
                }
            }
        } else if segue.identifier == Segues.eventWithoutRSVPJoinedPopup {
            //let vc = segue.destination as? EventJoinedPopupViewController
            //vc?.event = event
        } else if segue.identifier == Segues.eventCategorySegue {
                  if let vc = segue.destination as? EventCategoryListViewController {
                 //     vc.selUniversity = selUniversity
                   if let category = sender as? Interest {
                           vc.interestList = eventCategory
                            vc.type = .event
                            vc.interest = category
                    }
            }
        }
    }
}
