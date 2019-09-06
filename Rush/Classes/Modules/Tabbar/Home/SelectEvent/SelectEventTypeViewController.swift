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

enum ScreenType {
    case none
    case club
    case event
    case classes
}

protocol SelectEventTypeDelegate: class {
    func createEventClub(_ type: EventType)
}

class SelectEventTypeViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var eventCategoryView: UIView!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var heightConstraintOfContainerView: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintOfContainerView: NSLayoutConstraint!
    @IBOutlet weak var radiusView: UIView!
    
    var type: SelectEventType = .none
    var screenType: ScreenType = .none
    var eventType: EventType = .none
    weak var delegate: SelectEventTypeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.bottomConstraintOfContainerView.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.containerView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

// MARK: - Other function
extension SelectEventTypeViewController {
    func setupUI() {
        radiusView.layer.cornerRadius = 24
        radiusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        if type == .eventCategory {
            heightConstraintOfContainerView.constant = 214
            eventCategoryView.isHidden = false
            eventView.isHidden = true
        } else if type == .event {
            heightConstraintOfContainerView.constant = 426
            eventView.isHidden = false
            eventCategoryView.isHidden = true
        }
    }
    
    func dismiss() {
        if screenType == .event {
            Utils.notReadyAlert()
        } else {
            self.dismiss(animated: false, completion: nil)
            DispatchQueue.main.async {
                self.delegate?.createEventClub(self.eventType)
            }
        }
        
    }
}

// MARK: - Actions
extension SelectEventTypeViewController {
    
    @IBAction func dismissView() {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func eventButtonAction() {
        type = .event
        screenType = .event
        setupUI()
    }
    
    @IBAction func clubButtonAction() {
        type = .event
        screenType = .club
        setupUI()
    }
    
    @IBAction func publicButtonAction() {
        dismiss()
    }
    
    @IBAction func closedButtonAction() {
        dismiss()
    }
    
    @IBAction func inviteButtonAction() {
        dismiss()
    }
    
}

// MARK: - Navigation
extension SelectEventTypeViewController {
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }
     */
}
