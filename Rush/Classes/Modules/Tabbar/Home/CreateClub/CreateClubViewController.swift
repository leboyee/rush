//
//  CreateClubViewController.swift
//  Rush
//
//  Created by ideveloper on 20/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos
import IQKeyboardManagerSwift

class CreateClubViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraintOfTableView: NSLayoutConstraint!
    
    var nameClub = ""
    var clubDescription = ""
    var clubImage : UIImage?
    var isCreateGroupChat = true
    
    var selectedContactList = [Contact]()
    
    var cancelBtn : UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "cancel-active"), style: .plain, target: self, action: #selector(cancelButtonAction))
    }
    
    var saveBtnActive: UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "save-active"), style: .plain, target: self, action: #selector(saveButtonAction))
    }
    
    var saveBtnDisActive: UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "save-dark"), style: .plain, target: self, action: nil)
    }
    
    var interestList = [String]()
    var peopleList = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.isTranslucent = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    // MARK: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        
        topConstraintOfTableView.constant = -Utils.navigationHeigh
        
        // Set navigation buttons
        navigationItem.leftBarButtonItem = cancelBtn
        navigationItem.rightBarButtonItem = saveBtnDisActive
        
        // Setup tableview
        setupTableView()
        
        /*
         let total = screenWidth + 15
         
         topConstraintOfTapToChangeLabel.constant = total - 106
         heightConstraintOfImageView.constant = total
         
         scrollView.contentInset = UIEdgeInsets(top: (total - Utils.navigationHeigh)*0.81, left: 0, bottom: 0, right: 0)
         
         
         if userImageView.image != nil {
         addPhotoButton.isHidden = true
         navigationItem.rightBarButtonItem = saveBtnActive
         } else {
         hoverView.isHidden = true
         addPhotoButton.isHidden = false
         navigationItem.rightBarButtonItem = saveBtnDisActive
         }
         */
    }
}

// MARK: - Actions
extension CreateClubViewController {
    @IBAction func cancelButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonAction() {
        createClubAPI()
    }
    
    @IBAction func addImageButtonAction() {
        Utils.alert(message: nil, title: nil, buttons: ["Take Photo", "Photo Gallery"], cancel: "Cancel", type: .actionSheet) { [weak self] (index) in
            guard let unself = self else { return }
            if index != 2 {
                unself.openCameraOrLibrary(type: index == 0 ? .camera : .photoLibrary)
            }
        }
    }
}

// MARK: - Navigation
extension CreateClubViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.myClub {
            guard let vc = segue.destination as? MyClubViewController else { return }
            vc.clubImage = clubImage
        } else if segue.identifier == Segues.contactListSegue {
            guard let vc = segue.destination as? ContactsListViewController else { return }
            vc.isFromRegister = true
            vc.delegate = self
            vc.selectedItem = peopleList
        }
    }
}
