//
//  HomeViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SkeletonView

class HomeViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isShowTutorial = false
    var isShowJoinEvents = false
    var isShowSkeleton = true
    
    var date = Date()
    var notificationTitle = ""
    var notificationButtonTitle = ""
    
    var searchText = ""
    var pageNo = 1
    var clubList = [Club]()
    var eventList = [Event]()
    var classList = [SubClass]()
    
    var rightBarCreateButton: UIBarButtonItem?
    var dateButton: UIButton?
    var viewCalender: UIButton?
    var navigationView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = false
        
        // Show placeholder view
        updateSkeletonView(isShowSkeleton: true)
        
        getHomeList()
    }
    
    override func viewDidLayoutSubviews() {
        view.layoutSkeletonIfNeeded()
    }
    
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        
        if Utils.getDataFromUserDefault(kHomeTutorialKey) != nil {
            isShowTutorial = true
        }
        
        rightBarCreateButton = UIBarButtonItem(image: #imageLiteral(resourceName: "active-create"), style: .plain, target: self, action: #selector(createButtonAction))
        
        setupTableView()
        setupNavigation(isSkeleton: true)
        definesPresentationContext = true
    }
    
    func setupNavigation(isSkeleton: Bool) {
        self.view.backgroundColor = UIColor.bgBlack
                
        if isSkeleton {
        // Set navigation title (date)
            navigationView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth - 24, height: 59))
            dateButton = UIButton(frame: CGRect(x: 0, y: 0, width: 128, height: 24))
            viewCalender = UIButton(frame: CGRect(x: 0, y: 26, width: 104, height: 18))
        } else {
            navigationView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth - 130, height: 59))
            
            dateButton = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth - 130, height: 30))
            viewCalender = UIButton(frame: CGRect(x: 0, y: 30, width: 100, height: 18))
        }
        
        let text = Date().toString(format: "MMMM dd")
        dateButton?.setTitle(text, for: .normal)
        dateButton?.layer.cornerRadius = isSkeleton ? 8 : 0
        dateButton?.clipsToBounds = true
        dateButton?.setTitleColor(UIColor.white, for: .normal)
        dateButton?.titleLabel?.font = UIFont.displayBold(sz: 24)
        dateButton?.contentHorizontalAlignment = .left
        dateButton?.addTarget(self, action: #selector(viewCalenderBtnAction), for: .touchUpInside)
        if isSkeleton {
            dateButton?.isSkeletonable = true
            dateButton?.showAnimatedGradientSkeleton()
        }
        
        // View calender button setup
        viewCalender?.setTitle("View calendar", for: .normal)
        viewCalender?.contentHorizontalAlignment = .left
        viewCalender?.layer.cornerRadius = isSkeleton ? 8 : 0
        viewCalender?.clipsToBounds = true
        viewCalender?.setTitleColor(UIColor.gray47, for: .normal)
        viewCalender?.titleLabel?.font = UIFont.displaySemibold(sz: 13)
        viewCalender?.addTarget(self, action: #selector(viewCalenderBtnAction), for: .touchUpInside)
        
        if isSkeleton {
            viewCalender?.isSkeletonable = true
            viewCalender?.showAnimatedGradientSkeleton()
        }
        
        if let vw = navigationView {
            if let btn = dateButton { vw.addSubview(btn) }
            if let btn = viewCalender { vw.addSubview(btn) }
            navigationItem.titleView = navigationView
        }
    }
    
    func updateSkeletonView(isShowSkeleton: Bool) {
        if isShowSkeleton {
            tableView.isSkeletonable = true
            navigationItem.rightBarButtonItem = nil
            view.layoutSkeletonIfNeeded()
            view.showAnimatedGradientSkeleton()
        } else {
            self.isShowSkeleton = false
            view.hideSkeleton()
            tableView.isSkeletonable = false
            dateButton?.hideSkeleton()
            viewCalender?.hideSkeleton()
            
            dateButton?.removeFromSuperview()
            viewCalender?.removeFromSuperview()
            
            dateButton?.layer.cornerRadius = 0
            viewCalender?.layer.cornerRadius = 0
            
            setupNavigation(isSkeleton: false)
            
            navigationItem.rightBarButtonItem = rightBarCreateButton
            tableView.reloadData()
        }
    }
}

// MARK: - Actions
extension HomeViewController {
    @objc func createButtonAction() {
        // Segues.createClub
        // Segues.selectEventType
        // Segues.openPostScreen
        performSegue(withIdentifier: Segues.selectEventType, sender: nil)
    }
    
    @objc func viewCalenderBtnAction() {
        performSegue(withIdentifier: Segues.calendarHome, sender: nil)
    }
}

// MARK: - Mediator / Presenter Functions
extension HomeViewController {
    
    func showEvent(event: Event?) {
        performSegue(withIdentifier: Segues.homeEventDetail, sender: event)
    }
}

// MARK: - Navigation
extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.selectEventType {
            if let vc = segue.destination as? SelectEventTypeViewController {
                vc.type = .eventCategory
                vc.delegate = self
            }
        } else if segue.identifier == Segues.createPost {
            if let vc = segue.destination as? CreatePostViewController {
                vc.delegate = self
            }
        } else if segue.identifier == Segues.notificationAlert {
            if let vc = segue.destination as? NotificationAlertViewController {
                vc.toastMessage = notificationTitle
                vc.buttonTitle = notificationButtonTitle
                vc.delegate = self
            }
        } else if segue.identifier == Segues.clubListSegue {
            guard let vc = segue.destination as? ClubListViewController else { return }
            vc.hidesBottomBarWhenPushed = false
            vc.screenType = sender as? ClubListType ?? .none
        } else if segue.identifier == Segues.clubDetailSegue {
            guard let vc = segue.destination as? ClubDetailViewController else { return }
            vc.clubInfo = sender as? Club
        } else if segue.identifier == Segues.createEvent {
            guard let vc = segue.destination as? CreateEventViewController else { return }
            if let evenType = sender as? EventType {
                vc.eventType = evenType
            }
            vc.hidesBottomBarWhenPushed = true
        } else if segue.identifier == Segues.homeEventDetail {
            guard let vc = segue.destination as? EventDetailViewController else { return }
            if let event = sender as? Event {
                vc.eventId = String(event.id)
                vc.event = event
            }
        } else if segue.identifier == Segues.eventListSeuge {
            if let vc = segue.destination as? EventListViewController {
                vc.eventList = (sender as? [Event] ?? [Event]())
            }
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
