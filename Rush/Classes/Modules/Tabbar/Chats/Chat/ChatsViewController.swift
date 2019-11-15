//
//  ChatsViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import SendBirdSDK
import IQKeyboardManagerSwift

protocol ChatsViewControllerDelegate: class {
    func sharedResult(flg: Bool)
}

class ChatsViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blankView: UIView!
    
    var searchText = ""
    var isSearch = false
    var filterList: [SBDGroupChannel] = []
    var searchField: UITextField!
    
    // Sharing events
    var isOpenToShare = false
    var sharedEvent: Event?
    weak var delegate: ChatsViewControllerDelegate?

    var channels: [SBDGroupChannel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var clearBarButton: UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "grayDelete"), style: .plain, target: self, action: #selector(clearButtonAction))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        getListOfGroups()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        blankView.isHidden = true
        filterList = channels
        
        setupTableView()
        setupNavigation()
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.isTranslucent = false
        if isOpenToShare {
            setupSearchChatNavigation()
        } else {
            setupChatListNavigation()
        }
    }
    
    func setupChatListNavigation() {
        // Right item button
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "pencil-edit-button"), style: .plain, target: self, action: #selector(exitButtonAction))
        navigationItem.rightBarButtonItem = rightBarButton
        
        // Set left bar button and title
        let customView = UIView(frame: CGRect(x: 24, y: 0, width: screenWidth - 72, height: 44))
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth - 72, height: 44))
        let label = UILabel(frame: CGRect(x: 0, y: 5, width: screenWidth - 72, height: 30))
        label.text = "Search in chats"
        label.font = UIFont.displayBold(sz: 24)
        label.textColor = UIColor.navBarTitleWhite32
        customView.addSubview(label)
        customView.addSubview(searchButton)
        
        searchButton.addTarget(self, action: #selector(openSearchChatScreenButtonAction), for: .touchUpInside)
        
        navigationItem.titleView = customView
        navigationItem.leftBarButtonItem = nil
        
        channels = filterList
        tableView.reloadData()
    }
    
    func setupSearchChatNavigation() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        
        let customView = UIView(frame: CGRect(x: 48, y: 0, width: screenWidth - 48, height: 44))
        
        searchField = UITextField(frame: CGRect(x: 0, y: 6, width: screenWidth - 55, height: 28))
        searchField.font = UIFont.displayBold(sz: 24)
        searchField.textColor = UIColor.white
        searchField.returnKeyType = .search
        searchField.autocorrectionType = .no
        searchField.delegate = self
        searchField.becomeFirstResponder()
        let font = UIFont.displayBold(sz: 24)
        let color = UIColor.navBarTitleWhite32
        searchField.attributedPlaceholder = NSAttributedString(string: "Search in chats", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
        searchField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        customView.addSubview(searchField)
        navigationItem.titleView = customView
    }
}

// MARK: - Actions
extension ChatsViewController {
    @objc func createButtonAction() {
        Utils.notReadyAlert()
    }
    
    @objc func exitButtonAction() {
        performSegue(withIdentifier: Segues.chatContactListSegue, sender: nil)
    }
    
    @objc func openSearchChatScreenButtonAction() {
        setupSearchChatNavigation()
    }
    
    @objc func backButtonAction() {
        if self.isOpenToShare {
            self.dismiss(animated: true, completion: nil)
        } else {
            setupChatListNavigation()
        }
    }
    
    @objc func clearButtonAction() {
        searchField.text = ""
        channels = filterList
    }
}

// MARK: - Navigation
extension ChatsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.searchChatSegue {
            guard let vc = segue.destination as? ChatsViewController else { return }
            vc.isSearch = true
        } else if segue.identifier == Segues.chatContactListSegue {
            guard let vc = segue.destination as? ChatContactsListViewController else { return }
            vc.hidesBottomBarWhenPushed = true
        }
    }
}
