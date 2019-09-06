//
//  LogoutViewController.swift
//  Rush
//
//  Created by kamal on 12/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {
    
    @IBOutlet weak var verticalCentreConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.show()
        }
    }
}

// MARK: - Other Functions
extension LogoutViewController {
    
    private func dismiss() {
        verticalCentreConstraint.constant = screenHeight * 2/3
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
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
extension LogoutViewController {
    
    @IBAction func logoutButtonAction() {
        logout()
    }
    
    @IBAction func cancelButtonAction() {
        dismiss()
    }
}
