//
//  ExploreViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ExploreViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchfield: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var clubButton: UIButton!
    @IBOutlet weak var classButton: UIButton!
    @IBOutlet weak var peopleButton: UIButton!
    
    @IBOutlet weak var firstSeparator: UIView!
    @IBOutlet weak var secondSeparator: UIView!
    @IBOutlet weak var thirsSeparator: UIView!
    
    
    
    
    @IBOutlet weak var heightConstraintOfFilter: NSLayoutConstraint!
    
    var searchType: ExploreSearchType = .event
    
    var isShowJoinEvents = true
    var isSearch = false
    
    var university = "Harvard University"
    var notificationTitle = ""
    var notificationButtonTitle = ""
    
    var eventList : [String] = ["Art", "Music", "Technology", "Sports", "Beauty & style", "Startups", "Cars & trucks"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        if isSearch {
            searchfield.becomeFirstResponder()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
//        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        searchfield.returnKeyType = .go
        searchfield.delegate = self
        searchfield.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        
        heightConstraintOfFilter.constant = 0
        
        setupTableView()
        setupNavigation()
    }
    
    func setupNavigation() {
        
        // Right item button
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "changeLocation"), style: .plain, target: self, action: #selector(changeUniversity))
        navigationItem.rightBarButtonItem = rightBarButton
        
 
        // Set navigation title (date)
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth - 130, height: 59))
        let explore = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth - 130, height: 30))
        explore.text = Text.exploreIn
        explore.font = UIFont.DisplayBold(sz: 24)
        explore.textColor = UIColor.white
        
        // University button setup
        let universityButton = UIButton(frame: CGRect(x: 0, y: 26, width: screenWidth - 130, height: 18))
        universityButton.setTitle(university, for: .normal)
        universityButton.contentHorizontalAlignment = .left
        universityButton.setTitleColor(UIColor.gray47, for: .normal)
        universityButton.titleLabel?.font = UIFont.DisplaySemibold(sz: 13)
        navigationView.addSubview(explore)
        navigationView.addSubview(universityButton)
        navigationItem.titleView = navigationView
    }
    
    func updateFilterViewUI(selected: Int) {
        
        eventButton.setTitleColor(selected == 0 ? UIColor.white : UIColor.buttonDisableTextColor, for: .normal)
        clubButton.setTitleColor(selected == 1 ? UIColor.white : UIColor.buttonDisableTextColor, for: .normal)
        classButton.setTitleColor(selected == 2 ? UIColor.white : UIColor.buttonDisableTextColor, for: .normal)
        peopleButton.setTitleColor(selected == 3 ? UIColor.white : UIColor.buttonDisableTextColor, for: .normal)
        
        eventButton.backgroundColor = selected == 0 ? UIColor.bgBlack : UIColor.buttonDisableBgColor
        clubButton.backgroundColor = selected == 1 ? UIColor.bgBlack : UIColor.buttonDisableBgColor
        classButton.backgroundColor = selected == 2 ? UIColor.bgBlack : UIColor.buttonDisableBgColor
        peopleButton.backgroundColor = selected == 3 ? UIColor.bgBlack : UIColor.buttonDisableBgColor
        
        firstSeparator.backgroundColor = (selected == 0 || selected == 1) ? UIColor.bgBlack : UIColor.gray83
        secondSeparator.backgroundColor = (selected == 1 || selected == 2) ? UIColor.bgBlack : UIColor.gray83
        thirsSeparator.backgroundColor = (selected == 2 || selected == 3) ? UIColor.bgBlack : UIColor.gray83
    }
}

// MARK: - Actions
extension ExploreViewController {
    @objc func changeLocationButtonAction() {
        Utils.notReadyAlert()
    }
    
    @objc func changeUniversity() {
        performSegue(withIdentifier: Segues.universitySegue, sender: nil)
    }
    
    @IBAction func clearButtonAction() {
        searchfield.text = ""
        clearButton.isHidden = true
    }
    
    @IBAction func eventButtonAction(_ sender: Any) {
        if let btn = sender as? UIButton {
            
            if btn.tag == 1 || btn.tag == 2 {
                Utils.notReadyAlert()
                return
            }
            
            if btn.tag == 0 { // Event
                searchType = .event
            } else if btn.tag == 1 { // Club
                searchType = .club
            } else if btn.tag == 2 { // Classes
                searchType = .classes
            } else if btn.tag == 3 { // People
                searchType = .people
            } else {
                searchType = .none
            }
            updateFilterViewUI(selected: btn.tag)
        }
        
        tableView.reloadData()
    }
}



// MARK: - Navigation
extension ExploreViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.eventCategorySegue {
            if let vc = segue.destination as? EventCategoryListViewController {
                if let type = sender as? ScreenType {
                    vc.type = type
                } else {
                    vc.categoryName = sender as? String ?? ""
                    vc.type = .none
                }
            }
        }
    }
}