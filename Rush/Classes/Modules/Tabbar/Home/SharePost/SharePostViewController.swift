//
//  SharePostViewController.swift
//  Rush
//
//  Created by ideveloper on 27/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

enum SharePostType {
    case post
    case club
    case classes
    case profile
}

protocol SharePostViewControllerDelegate {
    func deletePost()
}

class SharePostViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heightConstraintOfContainerView: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintOfContainerView: NSLayoutConstraint!
    @IBOutlet weak var radiusView: UIView!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    
    var delegate: SharePostViewControllerDelegate?
    
    var type : SharePostType = .post

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func setupUI() {
        radiusView.layer.cornerRadius = 24
        radiusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        if type == .classes {
            deleteLabel.text = Text.deleteClass
        } else if type == .club {
            deleteLabel.text = Text.deleteClub
        } else if type == .profile {
            deleteLabel.text = Text.report
        } else {
            deleteLabel.text = Text.deletePost
        }
    }

}

// MARK: - Actions
extension SharePostViewController {
    @IBAction func shareButtonAction() {
        dismissView()
    }
    
    @IBAction func deletePostButtonAction() {
        dismissView()
        DispatchQueue.main.async {
            self.delegate?.deletePost()
        }
    }
    
    @IBAction func dismissView() {
        dismiss(animated: false, completion: nil)
    }
}

// MARK: - Navigation
extension SharePostViewController {
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    */
}
