//
//  CreateClubViewController.swift
//  Rush
//
//  Created by ideveloper on 20/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

class OtherUserProfileController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraintOfImageView: NSLayoutConstraint!
    @IBOutlet weak var topConstraintOfLabel: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var topConstraintOfScrollViw: NSLayoutConstraint!
    
    var isShowMessageButton = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    //MARk: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        
        scrollView.delegate = self
        
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let total = (screenWidth * 0.85) + Utils.navigationHeigh + 18
        heightConstraintOfImageView.constant = total
        
        scrollView.contentInset = UIEdgeInsets(top: (total * 0.5223), left: 0, bottom: 0, right: 0)
//        topConstraintOfScrollViw.constant = (total * 0.5223) + Utils.navigationHeigh + 18
        
        topConstraintOfLabel.constant = (total * 0.6)
        
        // share button
        let share = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(shareButtonAction))
        navigationItem.rightBarButtonItem = share
        
        // back button
        let cancel = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(cancelButtonAction))
        navigationItem.leftBarButtonItem = cancel
        
        setupTableView()
    }
    
    func openFriendListController() {
        performSegue(withIdentifier: Segues.friendList, sender: nil)
    }
}

//MARK: - Actions
extension OtherUserProfileController {
    @IBAction func cancelButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func shareButtonAction() {
        performSegue(withIdentifier: "ProfileInformationSegue", sender: nil)
    }
    
    @IBAction func infoButtonAction() {
        performSegue(withIdentifier: "ProfileInformationSegue", sender: nil)
    }
}

//MARK: - Scroll delegate
extension OtherUserProfileController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = scrollView.contentOffset.y
        
        if scrollView == self.scrollView {
            if yOffset == 0 {
                tableView.isScrollEnabled = true
            } else {
                tableView.isScrollEnabled = false
            }
        }
    }
}

// MARK: - Navigation
extension OtherUserProfileController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.notificationAlert {
            let controller = segue.destination as! NotificationAlertViewController
            if let message = sender as? String {
                controller.toastMessage = message
                controller.delegate = self
            }
        } else if segue.identifier == Segues.friendList {
            let vc = segue.destination as! FriendsListViewController
            vc.type = sender as? UserProfileDetailType ?? .none
        }
    }
}
