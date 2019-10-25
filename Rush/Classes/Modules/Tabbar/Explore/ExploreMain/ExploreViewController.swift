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
    
    var searchText = ""
    
    var university = "Harvard University"
    var notificationTitle = ""
    var notificationButtonTitle = ""
    
    // var dataList = [Any]()
    var pageNo = 1
    var isNextPageExist = true
    var classCatPageNo = 1
    var isClassCatIsNextPageExist = true
    var clubCatPageNo = 1
    var isClubCatIsNextPageExist = true
    var eventCatPageNo = 1
    var isEventCatIsNextPageExist = true
    
    var clubList = [Club]()
    var eventList = [Event]()
    var classList = [SubClass]()
    
    var clubInterestList = [Interest]()
    var eventInterestList = [Interest]()
    var classCategoryList = [Class]()
    var peopleList = [User]()
    var universityButton = UIButton()
    var selUniversity = University()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        searchType = .event
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isSearch {
            if searchType == .event {
                getEventCategoryListAPI()
            } else if searchType == .club {
                getClubCategoryListAPI()
            } else if searchType == .classes {
                getClassCategoryAPI()
            } else if searchType == .people {
                getPeopleListAPI()
            }
        }
        getClubListAPI(sortBy: "feed")
        getEventList(sortBy: .upcoming)
        getClassListAPI()
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
        explore.font = UIFont.displayBold(sz: 24)
        explore.textColor = UIColor.white
        
        // University button setup
        universityButton = UIButton(frame: CGRect(x: 0, y: 26, width: screenWidth - 130, height: 18))
        if selUniversity.universityName != "" {
            university = selUniversity.universityName
        } else {
            university = Authorization.shared.profile?.university?.first?.universityName ?? ""
            selUniversity = Authorization.shared.profile?.university?.first ?? selUniversity
        }
        universityButton.setTitle(university, for: .normal)
        universityButton.contentHorizontalAlignment = .left
        universityButton.setTitleColor(UIColor.gray47, for: .normal)
        universityButton.titleLabel?.font = UIFont.displaySemibold(sz: 13)
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
        pageNo = 1
        isNextPageExist = true
        classCatPageNo = 1
        isClassCatIsNextPageExist = true
        clubCatPageNo = 1
        isClubCatIsNextPageExist = true
        eventCatPageNo = 1
        isEventCatIsNextPageExist = true
        
        clubList = [Club]()
        eventList = [Event]()
        classList = [SubClass]()
        
        clubInterestList.removeAll()
        eventInterestList.removeAll()
        classCategoryList.removeAll()
        peopleList.removeAll()
        
        performSegue(withIdentifier: Segues.universitySegue, sender: nil)
    }
    
    @IBAction func clearButtonAction() {
        searchfield.text = ""
        searchText = ""
        searchfield.resignFirstResponder()
        isSearch = false
        heightConstraintOfFilter.constant = 0
        clearButton.isHidden = true
        tableView.reloadData()
        //        textFieldDidChanged(searchfield)
    }
    
    @IBAction func eventButtonAction(_ sender: Any) {
        if let btn = sender as? UIButton {
            
            //dataList.removeAll()
            
            if btn.tag == 0 { // Event
                searchType = .event
                getEventCategoryListAPI()
            } else if btn.tag == 1 { // Club
                searchType = .club
                getClubCategoryListAPI()
            } else if btn.tag == 2 { // Classes
                searchType = .classes
                getClassCategoryAPI()
            } else if btn.tag == 3 { // People
                searchType = .people
                getPeopleListAPI()
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
                } else if let category = sender as? EventCategory {
                    vc.eventCategory = category
                    vc.type = .event
                } else if let category = sender as? Interest {
                    vc.interest = category
                    if searchType == .event {
                        vc.interestList = eventInterestList
                        vc.type = .event
                    } else if searchType == .club {
                        vc.interestList = clubInterestList
                        vc.type = .club
                    }
                } else if let category = sender as? ClubCategory {
                    vc.clubCategory = category
                    //                    vc.clubCategoryList = clubInterestList
                    vc.type = .club
                } else if let category = sender as? Class {
                    vc.classCategory = category
                    vc.classCategoryList = classCategoryList
                    vc.type = .classes
                }
            }
        } else if segue.identifier == Segues.clubDetailSegue {
            guard let vc = segue.destination as? ClubDetailViewController else { return }
            vc.clubInfo = sender as? Club
        } else if segue.identifier == Segues.classDetailSegue {
            guard let vc = segue.destination as? ClassDetailViewController else { return }
            vc.subclassInfo = sender as? SubClass
        } else if segue.identifier == Segues.eventDetailSegue {
            guard let vc = segue.destination as? EventDetailViewController else { return }
            if let event = sender as? Event {
                vc.eventId = String(event.id)
                vc.event = event
            }
        } else if segue.identifier == Segues.otherUserProfile {
            let vc = segue.destination as? OtherUserProfileController
            let user = sender as? User
            vc?.userInfo = user
            vc?.delegate = self
        } else if segue.identifier == Segues.universitySegue {
            let vc = segue.destination as? UniversityViewController
            vc?.delegate = self
        }
        
    }
}
