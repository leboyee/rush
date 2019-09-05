//
//  CreateClubViewController.swift
//  Rush
//
//  Created by ideveloper on 20/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

class MyClubViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraintOfTableView: NSLayoutConstraint!
    
    var interestList = [String]()
    var peopleList = [String]()
    
    var clubImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    //MARk: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        
        /*
         let total = screenWidth + 15
         heightConstraintOfImageView.constant = total
         
         scrollView.contentInset = UIEdgeInsets(top: (total - Utils.navigationHeigh)*0.81, left: 0, bottom: 0, right: 0)
         */
        
        topConstraintOfTableView.constant = -Utils.navigationHeigh
        
        // share button
        let share = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(shareButtonAction))
        navigationItem.rightBarButtonItem = share
        
        // back button
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        navigationItem.leftBarButtonItem = back
        
        // setup tableview
        setupTableView()
    }
}

// MARK: - Actions
extension MyClubViewController {
    @IBAction func backButtonAction() {
        let viewControllers = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: false)
    }
    
    @objc func shareButtonAction() {
        performSegue(withIdentifier: Segues.sharePostSegue, sender: nil)
    }
}

// MARK: - Navigation
extension MyClubViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.otherUserProfile {
            if let vc = segue.destination as? OtherUserProfileController {
                // image for test
                vc.clubImage = #imageLiteral(resourceName: "bound-add-img")
                vc.delegate = self
            }
        } else if segue.identifier == Segues.sharePostSegue {
            if let vc = segue.destination as? SharePostViewController {
                vc.type = .club
            }
        }
    }
}
