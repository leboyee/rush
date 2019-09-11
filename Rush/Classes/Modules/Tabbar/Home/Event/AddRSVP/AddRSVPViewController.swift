//
//  CreateEventViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AddRSVPViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var rsvpArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.isTranslucent = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
 
    // MARK: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        
       
        // Setup tableview
        setupTableView()
        
        /*
        let total = screenWidth + 15
        
        topConstraintOfTapToChangeLabel.constant = total - 106
        heightConstraintOfImageView.constant = total
        
        scrollView.contentInset = UIEdgeInsets(top: (total - Utils.navigationHeigh)*0.81, left: 0, bottom: 0, right: 0)
        
        
        if userImageView.image != nil {
            addPhotoButton.isHidden = true
            navigationItem.rightBarButtonItem = saveBtnActive
        } else {
            hoverView.isHidden = true
            addPhotoButton.isHidden = false
           navigationItem.rightBarButtonItem = saveBtnDisActive
        }
        */
    }
}

// MARK: - Actions
extension AddRSVPViewController {
    
    @objc func saveButtonAction() {
    }
    
    @IBAction func addImageButtonAction() {
    }
}

// MARK: - Mediator
extension AddRSVPViewController {
    
}

// MARK: - Navigation
extension AddRSVPViewController {

}

