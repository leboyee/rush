//
//  SearchEventViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 28/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SearchEventViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noEventsView: UIView!

    var selectedIndex = -1
    var searchText = ""
    var pageNo = 1
    var dataList = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.bgBlack
        navigationController?.navigationBar.barTintColor = UIColor.bgBlack

        navigationController?.navigationBar.isTranslucent = false
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         navigationController?.navigationBar.backgroundColor = UIColor.clear
         navigationController?.navigationBar.barTintColor = UIColor.clear
     }
    
    func setup() {
        setupUI()
        noEventsView.isHidden = true
        getEventList(sortBy: .none)
    }
    
    func setupUI() {
        setupTableView()
        setupNavigation()
    }
    
    func setupNavigation() {
        
        // Set left bar button and title
        let customView = UIView(frame: CGRect(x: 48, y: 0, width: screenWidth - 48, height: 44))
        
            let searchTextField = UITextField(frame: CGRect(x: 0, y: -3, width: screenWidth - 48, height: 44))
            searchTextField.font = UIFont.displayBold(sz: 24)
            searchTextField.textColor = UIColor.white
            searchTextField.returnKeyType = .go
            searchTextField.autocorrectionType = .no
            searchTextField.delegate = self
            let font = UIFont.displayBold(sz: 24)
            let color = UIColor.navBarTitleWhite32
            searchTextField.attributedPlaceholder = NSAttributedString(string: "Search event", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
            searchTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
            customView.addSubview(searchTextField)
            navigationItem.titleView = customView
        }
}

// MARK: - Actions
extension SearchEventViewController {
    @objc func createButtonAction() {
        Utils.notReadyAlert()
    }
    
    @objc func openSearchClubScreenButtonAction() {
        Utils.notReadyAlert()
    }
}

// MARK: - Navigation
extension SearchEventViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.searchEventCategoryViewSegue {
            guard let indexPath = sender as? IndexPath else { return }
            guard let vc = segue.destination as?
                EventCategoryListViewController else { return }
            let category = self.dataList[indexPath.row] as? EventCategory
            vc.eventCategory = category
            vc.type = .event
        }
    }
}
