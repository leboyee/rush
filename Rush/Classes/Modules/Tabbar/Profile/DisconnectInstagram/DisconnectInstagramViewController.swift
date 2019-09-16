//
//  DisconnectInstagramViewController.swift
//  Rush
//
//  Created by kamal on 12/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

protocol DisconnectInstagraaDelegate: class {
    func disconnectInstagram()
}

class DisconnectInstagramViewController: UIViewController {

    @IBOutlet weak var verticalCentreConstraint: NSLayoutConstraint!
    weak var delegate: DisconnectInstagraaDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.show()
        }
    }
}

// MARK: - Other Functions
extension DisconnectInstagramViewController {

    func dismiss() {
        verticalCentreConstraint.constant = screenHeight * 2/3
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
            self.delegate?.disconnectInstagram()
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
extension DisconnectInstagramViewController {
    
    @IBAction func disconnectButtonAction() {
        disconnect()
    }
    
    @IBAction func cancelButtonAction() {
        dismiss()
    }
    
}
