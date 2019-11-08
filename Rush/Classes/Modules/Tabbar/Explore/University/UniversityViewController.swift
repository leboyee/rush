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
    
    var universityArray = [University]()
    var pageNo: Int = 1
    var isNextPageExist: Bool = false
    weak var delegate: UniversityViewControllerDelegate?
    var searchText = ""
    var searchTextFiled: UITextField?
    var selectedUniversity: University?
    
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
