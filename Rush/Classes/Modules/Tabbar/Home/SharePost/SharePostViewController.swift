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
    case event
    case classes
    case profile
}

protocol SharePostViewControllerDelegate: class {
    func delete(type: SharePostType, object: Any?)
}

class SharePostViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heightConstraintOfContainerView: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintOfContainerView: NSLayoutConstraint!
    @IBOutlet weak var radiusView: UIView!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var heightConstraintOfDeletePost: NSLayoutConstraint!
    
    weak var delegate: SharePostViewControllerDelegate?
    
    var type: SharePostType = .post
    var object: Any?
    var post: Post?
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
        
        if type == .event {
            deleteLabel.text = Text.deleteEvent
        } else if type == .classes {
            deleteLabel.text = Text.deleteClass
        } else if type == .club {
            deleteLabel.text = Text.deleteClub
        } else if type == .profile {
            deleteLabel.text = Text.report
        } else {
            deleteLabel.text = Text.deletePost
        }
        if post != nil {
            if post?.user?.userId != Authorization.shared.profile?.userId {
                hideDeleteOption()
            }
        } /*else if object != nil, let club = object as? Club {
            if club.user?.userId != Authorization.shared.profile?.userId {
                hideDeleteOption()
            }
        }*/
    }
    
    func hideDeleteOption() {
        heightConstraintOfContainerView.constant -= heightConstraintOfDeletePost.constant
        heightConstraintOfDeletePost.constant = 0
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
            self.delegate?.delete(type: self.type, object: self.object)
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
