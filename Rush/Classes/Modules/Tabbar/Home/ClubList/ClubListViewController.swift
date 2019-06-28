//
//  ClubListViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ClubListViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isShowJoinEvents = true
    
    var date = "January 24"
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
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "plus_white"), style: .plain, target: self, action: #selector(createButtonAction))
        navigationItem.rightBarButtonItem = rightBarButton
         
        navigationItem.titleView = Utils.getNavigationBarTitle(title: "Search clubs", textColor: UIColor.navBarTitleWhite32)
    }
    
    func openCreateClubViewController() {
        performSegue(withIdentifier: Segues.createClub, sender: nil)
    }
}

// MARK: - Actions
extension ClubListViewController {
    @objc func createButtonAction() {
//        performSegue(withIdentifier: Segues.selectEventType, sender: nil)
    }
}



// MARK: - Navigation
extension ClubListViewController {
    
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
            let controller = segue.destination as! NotificationAlertViewController
            controller.toastMessage = notificationTitle
            controller.buttonTitle = notificationButtonTitle
            controller.delegate = self
        }
    }
}
