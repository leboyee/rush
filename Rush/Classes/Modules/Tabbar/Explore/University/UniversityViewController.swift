//
//  UniversityViewController.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class UniversityViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndex = -1
    var universityArray = [University]()
    var pageNo: Int = 1
    var isNextPageExist: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        getUniversity(searchText: "")
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack
        
        // Setup tableview
        setupTableView()
        
        // Set navigation title
        navigationItem.titleView = Utils.getNavigationBarTitle(title: "University/school", textColor: UIColor.navBarTitleWhite32)
        
        //navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - Actions
extension UniversityViewController {
    
}

// MARK: - Navigation
extension UniversityViewController {
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }
     */
    
  /*  func routeToParent(segue: UIStoryboardSegue?)
     {
       // Get the destination view controller and data store
       let destinationVC = self.presentingViewController as! ExploreViewController
        var destinationDS = destinationVC.select
    
       // Pass data to the destination data store
       passDataToParent(source: dataStore!, destination: &destinationDS)
    
       // Navigate to the destination view controller
       navigateToParent(source: self, destination: destinationVC)
     }
    
     func passDataToParent(source: ChildDataStore, destination: inout ParentDataStore)
     {
       // Pass data backward
       destination.name = source.name
     }
    
     func navigateToParent(source: ChildViewController, destination: ParentViewController)
     {
       // Navigate backward (dismissing)
       source.dismiss(animated: true, completion: nil)
     } */
}
