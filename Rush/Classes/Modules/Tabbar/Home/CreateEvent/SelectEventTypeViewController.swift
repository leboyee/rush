//
//  SelectEventTypeViewController.swift
//  Rush
//
//  Created by ideveloper on 17/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

enum SelectEventType {
    case none
    case eventCategory
    case event
}

class SelectEventTypeViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var eventCategoryView: UIView!
    @IBOutlet weak var heightConstraintOfContainerView: NSLayoutConstraint!
    
    var type : SelectEventType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

// MARK: - Other function
extension SelectEventTypeViewController {
    func setupUI() {
        if type == .eventCategory {
            heightConstraintOfContainerView.constant = 214
            eventCategoryView.isHidden = false
        }
    }
}

// MARK: - Actions
extension SelectEventTypeViewController {
    @IBAction func eventButtonAction() {
        
    }
    
    @IBAction func clubButtonAction() {
        
    }
}

// MARK: - Navigation
extension SelectEventTypeViewController {
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }
     */
}
