//
//  SearchClubViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

enum SearchClubType {
    case none
    case searchList
    case searchCategory
    case classes
}

class SearchClubViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var date = "January 24"
    var notificationTitle = ""
    var notificationButtonTitle = ""
    
    var selectedIndex = -1
    
    var searchType: SearchClubType = .none
    var searchText = ""
    
    var categoryList: [String] = ["Art", "Music", "Technology", "Sports", "Beauty & style", "Startups", "Cars & trucks"]
    var classesList: [String] = ["101-01", "101-02", "101-03", "102-01", "102-02", "102-03", "103-A", "103-B", "103-C"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isTranslucent = false
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
        
        setupNavigation()
    }
    
    func setupNavigation() {
        
        // Set left bar button and title
        let customView = UIView(frame: CGRect(x: 48, y: 0, width: screenWidth - 48, height: 44))
        
        if searchType == .searchList {
            let searchTextField = UITextField(frame: CGRect(x: 0, y: -3, width: screenWidth - 48, height: 44))
            searchTextField.font = UIFont.displayBold(sz: 24)
            searchTextField.textColor = UIColor.white
            searchTextField.returnKeyType = .go
            searchTextField.autocorrectionType = .no
            searchTextField.delegate = self
            let font = UIFont.displayBold(sz: 24)
            let color = UIColor.navBarTitleWhite32
            searchTextField.attributedPlaceholder = NSAttributedString(string: "Search clubs", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
            searchTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
            customView.addSubview(searchTextField)
            navigationItem.titleView = customView
        } else {
            navigationItem.titleView = Utils.getNavigationBarTitle(title: searchText, textColor: UIColor.navBarTitleWhite32)
        }
    }
}

// MARK: - Actions
extension SearchClubViewController {
    @objc func createButtonAction() {
        Utils.notReadyAlert()
    }
    
    @objc func openSearchClubScreenButtonAction() {
        Utils.notReadyAlert()
    }
}

// MARK: - Navigation
extension SearchClubViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
