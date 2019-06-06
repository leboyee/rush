//
//  FriendsListViewController.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

enum UserProfileDetailType {
    case none
    case friends
    case events
    case clubs
    case classes
}

class FriendsListViewController: UIViewController {

    var type : UserProfileDetailType = .clubs
    @IBOutlet weak var firstSegmentButton: UIButton!
    @IBOutlet weak var secondSegmentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.bgBlack
        navigationController?.navigationBar.barTintColor = UIColor.bgBlack
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupUI() {
        selectedSegment(tag: 0)
        setupTableView()
    }
    
    func selectedSegment(tag: Int) {
        if tag == 1 {
            secondSegmentButton.setTitleColor(UIColor.white, for: .normal)
            secondSegmentButton.backgroundColor = UIColor.bgBlack
            
            firstSegmentButton.setTitleColor(UIColor.buttonDisableTextColor, for: .normal)
            firstSegmentButton.backgroundColor = UIColor.white
            firstSegmentButton.isSelected = false
            secondSegmentButton.isSelected = true
        } else {
            secondSegmentButton.setTitleColor(UIColor.buttonDisableTextColor, for: .normal)
            secondSegmentButton.backgroundColor = UIColor.white
            
            firstSegmentButton.setTitleColor(UIColor.white, for: .normal)
            firstSegmentButton.backgroundColor = UIColor.bgBlack
            firstSegmentButton.isSelected = true
            secondSegmentButton.isSelected = false
        }
        
        var firstTitle = ""
        var secondTitle = ""
        if type == .friends {
            firstTitle = "122 friends"
            secondTitle = "20 not going"
        } else if type == .events {
            firstTitle = "4 attending"
            secondTitle = "3 managed"
        } else if type == .clubs {
            firstTitle = "3 joind"
            secondTitle = "0 managed"
        }
        
        firstSegmentButton.setTitle(firstTitle, for: .normal)
        secondSegmentButton.setTitle(secondTitle, for: .normal)
    }
}

//MARK: - Actions
extension FriendsListViewController {
    @IBAction func firstSegmentButtonAction() {
        if firstSegmentButton.isSelected {
            return
        }
        selectedSegment(tag: 0)
    }
    
    @IBAction func secondSegmentButtonAction() {
        if secondSegmentButton.isSelected {
            return
        }
        selectedSegment(tag: 1)
    }
}

// MARK: - Navigation
extension FriendsListViewController {
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }
     */
}
