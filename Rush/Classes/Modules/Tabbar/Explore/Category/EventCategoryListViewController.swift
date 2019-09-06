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
    
    var categoryName = ""
    
    var isFirstFilter = false
    var isSecondFilter = false
    var isThirdFilter = false
    
    var type: ScreenType = .none
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.barTintColor = UIColor.clear
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack
        
        // Setup tableview
        setupTableView()
        
        // Setup collectionview
        setupCollectionView()
        
        // Set navigation title
        
        categoryName = type == .event ? "Search events" : type == .club ? "Search clubs" : type == .classes ? "Search classes" : categoryName
        
        navigationItem.titleView = Utils.getNavigationBarTitle(title: categoryName, textColor: type == .none ? UIColor.white : UIColor.navBarTitleWhite32)
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
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }
     */
}
