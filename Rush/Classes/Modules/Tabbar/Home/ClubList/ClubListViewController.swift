//
//  ClubListViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

enum ClubListType {
    case none
    case event
    case club
    case classes
}

class ClubListViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isShowJoinEvents = true
    
    var date = "January 24"
    var notificationTitle = ""
    var notificationButtonTitle = ""
    
    var screenType: ClubListType = .none
    
    var searchText = ""
    var pageNoM = 1
    var pageNoO = 1
    var isNextPageM = false
    var isNextPageO = false
    
    var clubList = [Club]()
    var classesList = [Class]()
    var myClubsList = [Club]()
    var myClassesList = [ClassJoined]()
    
    var clubInterestList = [Interest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pageNoM = 1
        pageNoO = 1
        isNextPageM = false
        isNextPageO = false
        
        if screenType == .club {
            getMyClubListAPI(sortBy: "my")
            getClubCategoryListAPI()
        } else {
            getMyJoinedClasses(search: "")
            getClassCategoryAPI()
        }
    }
    
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
        setupNavigation()
    }
    
    func setupNavigation() {
        
        // Right item button
       /* if screenType == .club {
            let rightBarButton = UIBarButtonItem(image: UIImage(named: "plus_white"), style: .plain, target: self, action: #selector(createButtonAction))
            navigationItem.rightBarButtonItem = rightBarButton
        } */
        
        // Set left bar button and title
        let customView = UIView(frame: CGRect(x: screenType == .club ? 0 :48, y: 0, width: screenWidth - 48, height: 44))
        
        if screenType == .classes {
            let searchTextField = UITextField(frame: CGRect(x: 0, y: -3, width: screenWidth - 48, height: 44))
            searchTextField.font = UIFont.displayBold(sz: 24)
            searchTextField.textColor = UIColor.white
            searchTextField.returnKeyType = .go
            searchTextField.autocorrectionType = .no
            searchTextField.delegate = self
            let font = UIFont.displayBold(sz: 24)
            let color = UIColor.navBarTitleWhite32
            searchTextField.attributedPlaceholder = NSAttributedString(string: screenType == .club ? Text.searchClubs : Text.searchClasses, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
            searchTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
            customView.addSubview(searchTextField)
            navigationItem.titleView = customView
        } else {
            let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: screenWidth - 48, height: 44))
            
            let label = UILabel(frame: CGRect(x: screenType == .club ? -10 : 0, y: 2, width: screenWidth - 48, height: 30))
            label.text = screenType == .club ? Text.searchClubs : Text.searchClasses
            label.font = UIFont.displayBold(sz: 24)
            label.textColor = UIColor.navBarTitleWhite32
            customView.addSubview(label)
            customView.addSubview(searchButton)
            
            searchButton.addTarget(self, action: #selector(openSearchClubScreenButtonAction), for: .touchUpInside)
            
            navigationItem.titleView = customView
        }
    }
    
    func openCreateClubViewController() {
        performSegue(withIdentifier: Segues.createClub, sender: nil)
    }
}

// MARK: - Actions
extension ClubListViewController {
    @objc func createButtonAction() {
        Utils.notReadyAlert()
    }
    
    @objc func openSearchClubScreenButtonAction() {
        if screenType == .club {
            performSegue(withIdentifier: Segues.searchClubSegue, sender: nil)
        } else if screenType == .classes {
            performSegue(withIdentifier: Segues.searchClubSegue, sender: nil)
        }
    }
}

// MARK: - Navigation
extension ClubListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.selectEventType {
            if let vc = segue.destination as? SelectEventTypeViewController {
                vc.type = .eventCategory
                vc.delegate = self
            }
        } else if segue.identifier == Segues.openPostScreen {
            if let vc = segue.destination as? CreatePostViewController {
                vc.delegate = self
            }
        } else if segue.identifier == Segues.notificationAlert {
            if let controller = segue.destination as? NotificationAlertViewController {
                controller.toastMessage = notificationTitle
                controller.buttonTitle = notificationButtonTitle
                controller.delegate = self
            }
        } else if segue.identifier == Segues.searchClubSegue {
            guard let vc = segue.destination as? SearchClubViewController else { return }
            vc.searchType = screenType == .club ? .searchList : .classes
            vc.classObject = sender as? SubClass ?? SubClass()
        } else if segue.identifier == Segues.clubDetailSegue {
            guard let vc = segue.destination as? ClubDetailViewController else { return }
            vc.clubInfo = sender as? Club
            vc.delegate = self
        } else if segue.identifier == Segues.classDetailSegue {
            guard let vc = segue.destination as? ClassDetailViewController
                else { return }
            if let sn = sender as? ClassJoined {
                vc.selectedGroup = sn.classGroup
                vc.subclassInfo = sn.classes
            } else if let sn = sender as? SubClass {
                vc.subclassInfo = sn
            }
            vc.joinedClub = true
        }
    }
}
