//
//  RSVPViewController.swift
//  Rush
//
//  Created by kamal on 13/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

struct RSVPAnswer {
    var index: Int
    var answer: String
}

class RSVPViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var joinButtonView: UIView!
    @IBOutlet weak var joinButton: UIButton!

    var event: Event?
    var answers = [RSVPAnswer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return joinButtonView
    }
}

// MARK: - Setup and Privacy
extension RSVPViewController: UIGestureRecognizerDelegate {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
        
        //left gesture when back button hide or replaced
        if let gesture = navigationController?.interactivePopGestureRecognizer {
            gesture.delegate = self
        }
        
        setupTableView()
        //loadAllData()
    }
}

// MARK: - Action
extension RSVPViewController {

    @IBAction func joinButtonAction() {
        
    }
}

// MARK: - Other
extension RSVPViewController {

    func toggleJoinButton(isEnbled: Bool) {
        joinButton.isEnabled = isEnbled
    }
}
