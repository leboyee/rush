//
//  ChatsViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


class ChatsViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blankView: UIView!
    
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        blankView.isHidden = false
        
        setupTableView()
        
        setupNavigation()
    }
    
    func setupNavigation() {
        
        navigationController?.navigationBar.isTranslucent = false
        
        // Right item button
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "pencil-edit-button"), style: .plain, target: self, action: #selector(exitButtonAction))
        navigationItem.rightBarButtonItem = rightBarButton
        
        // Set left bar button and title
        let customView = UIView(frame: CGRect(x: 24, y: 0, width: screenWidth - 72, height: 44))
        
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth - 72, height: 44))
        
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: screenWidth - 72, height: 30))
        label.text = "Search in chats"
        label.font = UIFont.DisplayBold(sz: 24)
        label.textColor = UIColor.navBarTitleWhite32
        customView.addSubview(label)
        customView.addSubview(searchButton)
        
        searchButton.addTarget(self, action: #selector(openSearchChatScreenButtonAction), for: .touchUpInside)
        
        navigationItem.titleView = customView
    }
}

// MARK: - Actions
extension ChatsViewController {
    @objc func createButtonAction() {
        Utils.notReadyAlert()
    }
    
    @objc func exitButtonAction() {
        Utils.notReadyAlert()
    }
    
    @objc func openSearchChatScreenButtonAction() {
        
    }
}



// MARK: - Navigation
extension ChatsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
}
