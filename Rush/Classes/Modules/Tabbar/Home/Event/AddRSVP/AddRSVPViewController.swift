//
//  CreateEventViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol AddRsvpDelegate: class {
    func addRsvpData(_ rsvpArray: [String])
}

class AddRSVPViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var bottomViewContraint: NSLayoutConstraint!
    @IBOutlet weak var rsvpPlusButton: CustomButton!
    @IBOutlet weak var saveButton: CustomButton!
    weak var delegate: AddRsvpDelegate?

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
    }

    override func viewWillDisappear(_ animated: Bool) {

    }
 
    // MARK: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        
       rsvpArray.append("")
       saveButton.setRsvpSaveButton(isEnable: false)

        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        gestureView.addGestureRecognizer(panGesture)

        // Setup tableview
        setupTableView()
    
    }
}

// MARK: - Actions
extension AddRSVPViewController {
    
    @IBAction func addNewRSVPButtonAction() {
        addNewRSVP()
    }
    
    @IBAction func saveButtonAction() {
        self.view.endEditing(true)
        self.delegate?.addRsvpData(rsvpArray)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Other function
extension AddRSVPViewController {
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: self.view)
        if velocity.y > 0 {
            self.dismiss(animated: true, completion: nil)
        }
    
    }

}
// MARK: - Mediator
extension AddRSVPViewController {
    
}

// MARK: - Navigation
extension AddRSVPViewController {

}
