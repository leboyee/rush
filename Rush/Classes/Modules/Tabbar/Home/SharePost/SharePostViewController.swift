//
//  SharePostViewController.swift
//  Rush
//
//  Created by ideveloper on 27/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

protocol SharePostViewControllerDelegate {
    func deletePost()
}


class SharePostViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heightConstraintOfContainerView: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintOfContainerView: NSLayoutConstraint!
    
    var delegate: SharePostViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
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
