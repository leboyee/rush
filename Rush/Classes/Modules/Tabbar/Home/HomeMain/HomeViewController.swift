//
//  HomeViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class HomeViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isShowTutorial = true
    var isShowJoinEvents = false
    
    var date = "January 24"
    var notificationTitle = ""
    var notificationButtonTitle = ""
    
    var searchText = ""
    var pageNo = 1
    var clubList = [Club]()
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
        getClubListAPI(sortBy: "feed")
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
        
        // Right item button
        let img = UIImage(named: "active-create")
        let selector = #selector(createButtonAction)
        let rightBar = UIBarButtonItem(image: img, style: .plain, target: self, action: selector)
        navigationItem.rightBarButtonItem = rightBar
            
        /*
        // create the button
        let createImage  = UIImage(named: "active-create")!.withRenderingMode(.alwaysOriginal)
        let createButton = UIButton(frame: CGRect(x: 0, y: 0, width: 78, height: 36))
        createButton.setBackgroundImage(createImage, for: .normal)
        createButton.addTarget(self, action: #selector(createButtonAction), for:.touchUpInside)
        
        // here where the magic happens, you can shift it where you like
        createButton.transform = CGAffineTransform(translationX: -5, y: 5)
        
        // add the button to a container, otherwise the transform will be ignored
        let createButtonContainer = UIView(frame: createButton.frame)
        createButtonContainer.addSubview(createButton)
        let createButtonItem = UIBarButtonItem(customView: createButtonContainer)
        
        // add button shift to the side
        navigationItem.rightBarButtonItem = createButtonItem
        */
 
        // Set navigation title (date)
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth - 130, height: 59))
        let dateButton = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth - 130, height: 30))
        dateButton.setTitle(date, for: .normal)
        dateButton.setTitleColor(UIColor.white, for: .normal)
        dateButton.titleLabel?.font = UIFont.displayBold(sz: 24)
        dateButton.contentHorizontalAlignment = .left
        dateButton.addTarget(self, action: #selector(viewCalenderBtnAction), for: .touchUpInside)
        
        // View calender button setup
        let viewCalender = UIButton(frame: CGRect(x: 0, y: 30, width: 100, height: 18))
        viewCalender.setTitle("View calendar", for: .normal)
        viewCalender.contentHorizontalAlignment = .left
        viewCalender.setTitleColor(UIColor.gray47, for: .normal)
        viewCalender.titleLabel?.font = UIFont.displaySemibold(sz: 13)
        viewCalender.addTarget(self, action: #selector(viewCalenderBtnAction), for: .touchUpInside)
        navigationView.addSubview(dateButton)
        navigationView.addSubview(viewCalender)
        navigationItem.titleView = navigationView
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
            vc.hidesBottomBarWhenPushed = true
        } else if segue.identifier == Segues.homeEventDetail {
            guard let vc = segue.destination as? EventDetailViewController else { return }
            vc.eventId = (sender as? Event)?.id
            vc.event = sender as? Event
        }
    }
}
