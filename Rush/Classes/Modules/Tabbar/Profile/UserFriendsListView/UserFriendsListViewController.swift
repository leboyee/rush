//
//  UserFriendsListViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class UserFriendsListViewController: UIViewController {

    var type: UserProfileDetailType = .clubs
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var topConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var noSearchResultView: UIView!
    var searchTextFiled: UITextField?
    var rightBarButton: UIBarButtonItem?
    var friendsList = [Friend]()
    var pageNo = 1
    var userId: String = ""
    var isNextPageExist: Bool = false
    var isSearch: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack
        // Setup tableview
        setupTableView()
        getFriendListAPI()
        setupNavigation()
        noSearchResultView.isHidden = true
        // Set navigation title        
    }
    
    func setupNavigation() {
        
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
            searchTextFiled?.attributedPlaceholder = NSAttributedString(string: "Search friends", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
            searchTextFiled?.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        customView.addSubview(searchTextFiled ?? UITextField())
            navigationItem.titleView = customView
            self.view.backgroundColor = UIColor.bgBlack
        self.rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "plus_white"), style: .plain, target: self, action: #selector(plusButtonAction))
        self.navigationItem.rightBarButtonItem = self.rightBarButton
        
        let leftbarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .done, target: self, action: #selector(backButtonAction))
          navigationItem.leftBarButtonItem = leftbarButton

        }
    
}

// MARK: - Actions
extension UserFriendsListViewController {
    @objc func plusButtonAction() {
        if isSearch == true {
            isSearch = false
            rightBarButton?.image = #imageLiteral(resourceName: "plus_white")
            searchTextFiled?.text = ""
            pageNo = 1
            getFriendListAPI()
        } else {
            
        }
    }

    @objc func backButtonAction() {
          navigationController?.popViewController(animated: true)
      }

}

// MARK: - Navigation
extension UserFriendsListViewController {
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }
     */
}
