//
//  EventJoinedPopupViewController.swift
//  Rush
//
//  Created by kamal on 13/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class EventJoinedPopupViewController: UIViewController {

    @IBOutlet weak var verticalCentreConstraint: NSLayoutConstraint!
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.show()
        }
    }
    
}

// MARK: - Other Functions
extension EventJoinedPopupViewController {
    
    func dismiss() {
        verticalCentreConstraint.constant = screenHeight * 2/3
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    func showMessage(message: String) {
        Utils.alert(message: message)
    }
    
    private func show() {
        verticalCentreConstraint.constant = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            
        })
    }
}

// MARK: - Actions
extension EventJoinedPopupViewController {
    
    @IBAction func receiveEventUpdateButtonAction() {
        updateReceiveNotification()
    }
    
    @IBAction func cancelButtonAction() {
        dismiss()
    }
    
}
