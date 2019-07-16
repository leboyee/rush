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
        blankView.isHidden = true
        
        setupTableView()
        
        setupNavigation()
    }
    
    func setupNavigation() {
        
        navigationController?.navigationBar.isTranslucent = false
        
        // Right item button
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "pencil-edit-button"), style: .plain, target: self, action: #selector(exitButtonAction))
        navigationItem.rightBarButtonItem = rightBarButton
        
        // Set left bar button and title
        let customView = UIView(frame: CGRect(x: 48, y: 0, width: screenWidth - 48, height: 44))
        
        let searchTextField = UITextField(frame: CGRect(x: 24, y: -3, width: screenWidth - 130, height: 44))
        searchTextField.font = UIFont.DisplayBold(sz: 24)
        searchTextField.textColor = UIColor.white
        searchTextField.returnKeyType = .search
        searchTextField.delegate = self
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search in chats", attributes: [NSAttributedString.Key.font : UIFont.DisplayBold(sz: 24), NSAttributedString.Key.foregroundColor : UIColor.navBarTitleWhite32])
        searchTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        customView.addSubview(searchTextField)
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
}



// MARK: - Navigation
extension ChatsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
}
