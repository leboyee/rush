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
    var firstFilterIndex = 0
    var secondFilterIndex = 0
    var thirdFilterIndex = 0
    var searchText = ""
    var pageNo = 1
    var isOnlyFriendGoing: Int = 0
    var clubList = [Club]()
    var eventList = [Event]()
    var classList = [SubClass]()
    var classCategoryList = [Class]()
    var clubCategoryList = [ClubCategory]()
    var eventCategory: EventCategory?
    var clubCategory: ClubCategory?
    var classCategory: Class?
    var interest: Interest?
    var firstSortText = "All categories"
    var secondSortText = "Popular first"
    var thirdSortText = "All people"
    var eventDayFilter: EventCategoryDayFilter = .none
    var eventTimeFilter: EventCategoryTimeFilter = .allTime
    var startDate = ""
    var endDate = ""
    var startTime = ""
    var endTime = ""
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
            if (eventCategory) != nil {
                firstSortText = eventCategory?.name ?? "All categories"
            }
            getEventList(sortBy: .myUpcoming, eventCategory: eventCategory)
        case .club:
            if (clubCategory) != nil {
                firstSortText = clubCategory?.name ?? "All categories"
            }
            getClubListAPI(sortBy: "feed", clubCategory: clubCategory)
        case .classes:
            if (classCategory) != nil {
                firstSortText = classCategory?.name ?? "All categories"
            }
            getClassCategoryAPI()
//            getClassListAPI()
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
        if interest == nil {//open non category list screen
            titleText = type == .event ? "Search events" : type == .club ? "Search clubs" : type == .classes ? "Search classes" : ""
        } else {
            titleText = interest?.interestName ?? ""
        }
        
        if type == .event {
            firstSortText = "All upcoming"
            secondSortText = "Any time"
            thirdSortText = "All people"
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
