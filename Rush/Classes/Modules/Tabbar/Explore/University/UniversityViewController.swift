//
//  UniversityViewController.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

protocol UniversityViewControllerDelegate: class {
    func setSelectedUniversity(university: University)
}

class UniversityViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndex = -1
    var universityArray = [University]()
    var pageNo: Int = 1
    var isNextPageExist: Bool = false
    weak var delegate: UniversityViewControllerDelegate?
    var searchText = ""
    var searchTextFiled: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        getUniversity()
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack
        
        // Setup tableview
        setupTableView()
        
        // Set navigation title
//        navigationItem.titleView = Utils.getNavigationBarTitle(title: "University/school", textColor: UIColor.navBarTitleWhite32)
        
        // Set left bar button and title
        let customView = UIView(frame: CGRect(x: 48, y: 0, width: screenWidth - 48, height: 44))
        searchTextFiled = UITextField(frame: CGRect(x: 0, y: -3, width: screenWidth - 48, height: 44))
        searchTextFiled?.font = UIFont.displayBold(sz: 24)
        searchTextFiled?.textColor = UIColor.white
        searchTextFiled?.returnKeyType = .go
        searchTextFiled?.autocorrectionType = .no
        searchTextFiled?.delegate = self
        let font = UIFont.displayBold(sz: 24)
        let color = UIColor.navBarTitleWhite32
        searchTextFiled?.attributedPlaceholder = NSAttributedString(string: "University/school", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
        searchTextFiled?.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        customView.addSubview(searchTextFiled ?? UITextField())
        navigationItem.titleView = customView
        
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
