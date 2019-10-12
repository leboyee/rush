//
//  EventCategoryListViewController.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EventCategoryListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var topConstraintOfTableView: NSLayoutConstraint!
    
    var isFirstFilter = false
    var isSecondFilter = false
    var isThirdFilter = false
    
    var type: ScreenType = .none
    
    var searchText = ""
    var pageNo = 1
    var clubList = [Club]()
    var eventList = [Event]()
    var classList = [SubClass]()
    var classCategoryList = [Class]()
    var eventCategory: EventCategory?
    
    var firstSortText = "All categories"
    var secondSortText = "Popular first"
    var thirdSortText = "All people"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.bgBlack
        navigationController?.navigationBar.barTintColor = UIColor.bgBlack
        navigationController?.navigationBar.isTranslucent = false
        
        switch type {
        case .event:
            getEventList(sortBy: .upcoming, eventCategory: eventCategory)
        case .club:
            getClubListAPI(sortBy: "feed")
        case .classes:
            getClassCategoryAPI()
            getClassListAPI()
        default:
            break
        }
        
    }
        
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack
        // Setup tableview
        setupTableView()
        
        // Setup collectionview
        setupCollectionView()
        
        // Set navigation title
        
        var titleText = ""
        if eventCategory == nil {//open non category list screen
            titleText = type == .event ? "Search events" : type == .club ? "Search clubs" : type == .classes ? "Search classes" : ""
        } else {
            titleText = eventCategory?.name ?? ""
        }
        
        navigationItem.titleView = Utils.getNavigationBarTitle(title: titleText, textColor: eventCategory == nil ? UIColor.navBarTitleWhite32 : UIColor.white)

    }
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - Actions
extension EventCategoryListViewController {
    
}

// MARK: - Navigation
extension EventCategoryListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.eventDetailSegue {
            guard let vc = segue.destination as? EventDetailViewController else { return }
            if let event = sender as? Event {
               vc.eventId = String(event.id)
               vc.event = event
            }
        } else if segue.identifier == Segues.clubDetailSegue {
            guard let vc = segue.destination as? ClubDetailViewController else { return }
            vc.clubInfo = sender as? Club
        } else if segue.identifier == Segues.classDetailSegue {
            guard let vc = segue.destination as? ClassDetailViewController
                else { return }
            vc.subclassInfo = sender as? SubClass
            vc.joinedClub = true
        } else if segue.identifier == Segues.searchClubSegue {
            guard let vc = segue.destination as? SearchClubViewController else { return }
            //            vc.searchType = screenType == .club ? .searchList : .classes
            vc.searchType = .classes
            vc.classObject = sender as? SubClass ?? SubClass()
        }
    }
}
