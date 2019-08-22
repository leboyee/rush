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
        
        getMyClubListAPI(sortBy: "my")
    }
    
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
        
        setupNavigation()
    }
    
    func setupNavigation() {
        self.view.backgroundColor = UIColor.bgBlack
        
        // Right item button
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "active-create"), style: .plain, target: self, action: #selector(createButtonAction))
        navigationItem.rightBarButtonItem = rightBarButton
            
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
        dateButton.titleLabel?.font = UIFont.DisplayBold(sz: 24)
        dateButton.contentHorizontalAlignment = .left
        dateButton.addTarget(self, action: #selector(viewCalenderButtonAction), for: .touchUpInside)
        
        
        // View calender button setup
        let viewCalender = UIButton(frame: CGRect(x: 0, y: 30, width: 100, height: 18))
        viewCalender.setTitle("View calendar", for: .normal)
        viewCalender.contentHorizontalAlignment = .left
        viewCalender.setTitleColor(UIColor.gray47, for: .normal)
        viewCalender.titleLabel?.font = UIFont.DisplaySemibold(sz: 13)
        viewCalender.addTarget(self, action: #selector(viewCalenderButtonAction), for: .touchUpInside)
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
    
    @objc func viewCalenderButtonAction() {
        performSegue(withIdentifier: Segues.calendarHome, sender: nil)
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
            let vc = segue.destination as! NotificationAlertViewController
            vc.toastMessage = notificationTitle
            vc.buttonTitle = notificationButtonTitle
            vc.delegate = self
        } else if segue.identifier == Segues.clubListSegue {
            let vc = segue.destination as! ClubListViewController
            vc.hidesBottomBarWhenPushed = false
            vc.screenType = sender as? ClubListType ?? .none
        }
    }
}
