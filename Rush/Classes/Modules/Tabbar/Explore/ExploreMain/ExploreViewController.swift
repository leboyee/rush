//
//  ExploreViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ExploreViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isShowTutorial = false
    var isShowJoinEvents = true
    
    var university = "Harvard University"
    var notificationTitle = ""
    var notificationButtonTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
        
        setupNavigation()
    }
    
    func setupNavigation() {
        
        // Right item button
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "changeLocation"), style: .plain, target: self, action: #selector(createButtonAction))
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
    @objc func createButtonAction() {
        // Segues.createClub
        // Segues.selectEventType
        // Segues.openPostScreen
        performSegue(withIdentifier: Segues.selectEventType, sender: nil)
        
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
