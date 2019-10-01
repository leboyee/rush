//
//  RSVPViewController.swift
//  Rush
//
//  Created by kamal on 13/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

struct RSVPAnswer: Codable {
    var index: Int
    var ans: String
    
     private enum CodingKeys: String, CodingKey {
        case index
        case ans
    }
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
        tabBarController?.tabBar.isHidden = true

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
        view.endEditing(true)
        joinEvent()
    }
}

// MARK: - Other
extension RSVPViewController {

    func toggleJoinButton(isEnbled: Bool) {
        joinButton.isEnabled = isEnbled
    }
    
    func joinSuccessfully() {
        performSegue(withIdentifier: Segues.eventJoinedPopup, sender: nil)
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - Navigation
extension RSVPViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.eventJoinedPopup {
            let vc = segue.destination as? EventJoinedPopupViewController
            vc?.event = event
        }
    }
}
