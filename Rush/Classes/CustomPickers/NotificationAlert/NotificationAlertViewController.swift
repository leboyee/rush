
//
//  NotificationAlertViewController.swift
//  wolf
//
//  Created by iChirag on 02/07/18.
//  Copyright © 2018 Messapps. All rights reserved.
//

import UIKit

protocol NotificationAlertDelegate {
    func undoButtonClickEvent()
}


class NotificationAlertViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewConstraint: NSLayoutConstraint!
    
    var toastMessage = ""
    var delegate: NotificationAlertDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        titleLabel.text = toastMessage
        
        let total = 49 + 16 // Tabbar height + padding
        
        self.containerViewConstraint.constant = CGFloat(total)
        UIView.animate(withDuration: 0.3) {
            self.containerView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.dismissView()
        })
        
    }
    
    // MARK: - setup
    func setup() {
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        containerView.addGestureRecognizer(swipeUp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions
    func dismissView() {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func undoButtonAction() {
        dismiss(animated: true, completion: nil)
        delegate?.undoButtonClickEvent()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if swipeGesture.direction == UISwipeGestureRecognizer.Direction.down {
                dismissView()
            }
        }
    }
}

