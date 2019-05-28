//
//  CreateClubViewController.swift
//  Rush
//
//  Created by ideveloper on 20/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

class CreateClubViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraintOfImageView: NSLayoutConstraint!
    @IBOutlet weak var topConstraintOfTapToChangeLabel: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var hoverView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var interestList = [String]()
    var peopleList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    //MARk: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        
        let total = screenWidth + 15
        
        topConstraintOfTapToChangeLabel.constant = total - 106
        heightConstraintOfImageView.constant = total
        
        scrollView.contentInset = UIEdgeInsets(top: (total - Utils.navigationHeigh)*0.81, left: 0, bottom: 0, right: 0)
        
        if userImageView.image != nil {
            addPhotoButton.isHidden = true
            saveButton.titleLabel?.textColor = UIColor.lightGrayColor
            saveButton.setBackgroundImage(#imageLiteral(resourceName: "small-white-button-bg"), for: .normal)
        } else {
            hoverView.isHidden = true
            addPhotoButton.isHidden = false
            saveButton.titleLabel?.textColor = UIColor.bgBlack
            saveButton.setBackgroundImage(#imageLiteral(resourceName: "button-black-bg"), for: .normal)
        }
        setupTableView()
    }
}

//MARK: - Actions
extension CreateClubViewController {
    @IBAction func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageButtonAction() {
        Utils.alert(message: nil, title: nil, buttons: ["Take Photo", "Photo Gallery"], cancel : "Cancel", type: .actionSheet) {
            [weak self] (index) in
            guard let self_ = self else { return }
            if index != 2 {
                self_.openCameraOrLibrary(type: index == 0 ? .camera : .photoLibrary)
            }
        }
    }
}

// MARK: - Navigation
extension CreateClubViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
