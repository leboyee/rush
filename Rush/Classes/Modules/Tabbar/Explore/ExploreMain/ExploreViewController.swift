//
//  ExploreViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ExploreViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchfield: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var clubButton: UIButton!
    @IBOutlet weak var classButton: UIButton!
    @IBOutlet weak var peopleButton: UIButton!
    
    @IBOutlet weak var firstSeparator: UIView!
    @IBOutlet weak var secondSeparator: UIView!
    @IBOutlet weak var thirsSeparator: UIView!
    
    
    
    
    @IBOutlet weak var heightConstraintOfFilter: NSLayoutConstraint!
    
    var searchType: ExploreSearchType = .event
    
    var isShowJoinEvents = true
    var isSearch = false
    
    var university = "Harvard University"
    var notificationTitle = ""
    var notificationButtonTitle = ""
    
    var eventList : [String] = ["Art", "Music", "Technology", "Sports", "Beauty & style", "Startups", "Cars & trucks"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        searchfield.returnKeyType = .go
        searchfield.delegate = self
        searchfield.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        
        heightConstraintOfFilter.constant = 0
        
        setupTableView()
        setupNavigation()
    }
    
    func setupNavigation() {
        
        // Right item button
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "changeLocation"), style: .plain, target: self, action: #selector(changeLocationButtonAction))
        navigationItem.rightBarButtonItem = rightBarButton
        
 
        // Set navigation title (date)
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth - 130, height: 59))
        let explore = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth - 130, height: 30))
        explore.text = Text.exploreIn
        explore.font = UIFont.DisplayBold(sz: 24)
        explore.textColor = UIColor.white
        
        // View calender button setup
        
        let universityLabel = UILabel(frame: CGRect(x: 0, y: 30, width: screenWidth - 130, height: 18))
        universityLabel.text = university
        universityLabel.font = UIFont.DisplaySemibold(sz: 13)
        universityLabel.textColor = UIColor.gray47
        
        navigationView.addSubview(explore)
        navigationView.addSubview(universityLabel)
        navigationItem.titleView = navigationView
    }
}

// MARK: - Actions
extension ExploreViewController {
    @objc func changeLocationButtonAction() {
        Utils.notReadyAlert()
    }
    
    @IBAction func clearButtonAction() {
        searchfield.text = ""
    }
}



// MARK: - Navigation
extension ExploreViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.selectEventType {
            if let vc = segue.destination as? SelectEventTypeViewController {
                vc.type = .eventCategory
                vc.delegate = self
            }
        } else if segue.identifier == Segues.openPostScreen {
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
            vc.screenType = sender as? ClubListType ?? .none
        }
    }
}
