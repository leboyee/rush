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
    var clubCategoryList = [Interest]()
    var eventCategory: EventCategory?
//    var clubCategory: Interest?
    var classCategory: Class?
    var interest: Interest?
    var interestList = [Interest]()
    var firstSortText = "All categories"
    var secondSortText = "Popular first"
    var thirdSortText = "All people"
    var eventDayFilter: EventCategoryDayFilter = .none
    var eventTimeFilter: EventCategoryTimeFilter = .allTime
    var startDate = ""
    var endDate = ""
    var startTime = ""
    var endTime = ""
    var isToday = false
          
    var selUniversity = University()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        switch type {
        case .event:
//            if (eventCategory) != nil {
//                firstSortText = eventCategory?.name ?? "All categories"
//            }
            if interest?.interestName != "" {
                if isToday {
                    firstSortText = "Today"
                    firstFilterIndex = EventCategoryDayFilter.today.rawValue
                    filterType(eventType: .today)
                    selectedIndex("Today", IndexPath.init(row: EventCategoryDayFilter.today.rawValue, section: 0))
                } else {
                    getEventList(sortBy: .upcoming, eventCategoryId: "\(interest?.interestId ?? 0)")
                }
                
            } else {
                  getEventList(sortBy: .upcoming, eventCategoryId: eventCategory?.id)
            }
        case .club:
            if interest?.interestName != "" {
                firstSortText = interest?.interestName ?? "All categories"
                let value = interestList.firstIndex(where: { $0.interestName == firstSortText }) ?? 0
                firstFilterIndex = value
                getClubListAPI(sortBy: "feed", clubCategoryId: "\(interest?.interestId ?? 0)")
                getClubCategoryListAPI()
            } else if interest != nil {
                firstSortText = interest?.interestName ?? "All categories"
                let value = clubCategoryList.firstIndex(where: { $0.interestName == firstSortText }) ?? 0
                firstFilterIndex = value
                getClubListAPI(sortBy: "feed", clubCategoryId: String(interest?.interestId ?? 0))
            } else {
                getClubListAPI(sortBy: "feed", clubCategoryId: String(interest?.interestId ?? 0))
                getClubCategoryListAPI()
            }
        case .classes:
            if classCategory != nil {
                firstSortText = classCategory?.name ?? "All categories"
                let value = classCategoryList.firstIndex(where: { $0.name == firstSortText }) ?? 0
                firstFilterIndex = value
                getClassListAPI()
            } else {
                getClassListAPI()
                getClassCategoryAPI()
            }
        default:
            break
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.bgBlack
        navigationController?.navigationBar.barTintColor = UIColor.bgBlack
        navigationController?.navigationBar.isTranslucent = false
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
            /*var header = "Search classes"
            if (eventCategory) != nil {
                            header = eventCategory?.name ?? "Search events"
                        } */
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
            if let classObj = sender as? SubClass {
                vc.searchType = .classes
                vc.classObject = classObj
            }
            
        }
    }
}
