//
//  PhotoModelViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 20/11/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

protocol PhotoModelViewControllerDelegate: class {
    func delete(type: String, object: Any?)
    func savePhoto(_ object: Any?)
}

class PhotoModelViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var heightConstraintOfContainerView: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintOfContainerView: NSLayoutConstraint!
    @IBOutlet weak var radiusView: UIView!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var heightConstraintOfDeletePost: NSLayoutConstraint!
    
    weak var delegate: PhotoModelViewControllerDelegate?
    
    var object: Any?
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
        deleteLabel.text = "Delete"
    }
    
}

// MARK: - Actions
extension PhotoModelViewController {
    @IBAction func saveButtonAction() {
        dismissView()
        DispatchQueue.main.async {
            self.delegate?.savePhoto(self.object)
        }
    }
    
    @IBAction func deleteButtonAction() {
        dismissView()
        DispatchQueue.main.async {
            self.delegate?.delete(type: "", object: self.object)
        }
    }
    
    @IBAction func dismissView() {
        dismiss(animated: false, completion: nil)
    }
}

// MARK: - Navigation
extension PhotoModelViewController {
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }
     */
}
