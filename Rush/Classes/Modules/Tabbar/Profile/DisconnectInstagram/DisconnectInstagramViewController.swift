//
//  DisconnectInstagramViewController.swift
//  Rush
//
//  Created by kamal on 12/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class DisconnectInstagramViewController: UIViewController {

    @IBOutlet weak var verticalCentreConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.show()
        }
    }

    
}

//MARK: - Other Functions
extension DisconnectInstagramViewController {

    private func dismiss() {
        verticalCentreConstraint.constant = screenHeight * 2/3
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: { status in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    private func show() {
        verticalCentreConstraint.constant = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: { status in

        })
    }
    
}

//MARK: - Actions
extension DisconnectInstagramViewController {
    
    @IBAction func disconnectButtonAction() {
        Utils.notReadyAlert()
    }
    
    @IBAction func cancelButtonAction() {
        dismiss()
    }
    
}
