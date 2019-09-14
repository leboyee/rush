//
//  CreateEventViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AddLocationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var locationEntryTextField: UITextField!
    var searchedlocationArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchedlocationArray = ["Test title 1",
        "Test title 2",
        "Test title 3"]

        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.isTranslucent = true
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
 
    // MARK: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        gestureView.addGestureRecognizer(panGesture)

        // Setup tableview
        setupTableView()
    
    }
}

// MARK: - Actions
extension AddLocationViewController {
    
    @IBAction func clearUserEntryForLocationPressed() {
     self.locationEntryTextField.text = ""
    }
}

// MARK: - Other function
extension AddLocationViewController {
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: self.view)
        if velocity.y > 0 {
            self.dismiss(animated: true, completion: nil)
        }
    
    }

}
// MARK: - Mediator
extension AddLocationViewController {
    
}

// MARK: - Navigation
extension AddLocationViewController {

}
