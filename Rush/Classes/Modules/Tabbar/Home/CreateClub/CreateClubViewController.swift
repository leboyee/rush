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
    @IBOutlet weak var clubHeader: ClubHeader!
    @IBOutlet weak var backgroundView: RBackgoundView!
    @IBOutlet weak var heightConstraintOfHeader: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var selectedContactList = [Contact]()
    var nameClub = ""
    var clubDescription = ""
    var clubImage: UIImage?
    var isCreateGroupChat = true
    
    let headerFullHeight: CGFloat = 367
    let headerSmallWithDateHeight: CGFloat = 182
    let headerSmallWithoutDateHeight: CGFloat = 114
    
    var interestList = [String]()
    var peopleList = [Contact]()
    
    var clubInfo: Club?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        // set all data for manage(edit) club
        setupData()
        
        // Setup tableview
        setupTableView()
        
        // validate default fields
        validateAllFields()
        
        // Setup header
        fillImageHeader()
    }
    
    func setupData() {
        if let club = clubInfo {
            nameClub = club.clubName ?? ""
            clubDescription = club.clubDesc ?? ""
            isCreateGroupChat = (club.clubIsChatGroup ?? "0") == "1" ? true : false
            
            let interests = (club.clubInterests ?? "").components(separatedBy: ",")
            interestList = interests
        }
    }
}

// MARK: - Actions
extension CreateClubViewController {
    @IBAction func cancelButtonAction() {
        if clubInfo != nil {
            dismiss(animated: false, completion: nil)
        } else {
            navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func saveButtonAction() {
        if saveButton.isEnabled {
            if clubInfo != nil {
                // Update club info
                updateClubAPI()
            } else {
                // Create club info
                createClubAPI()
            }
        }
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
        } else if segue.identifier == Segues.clubDetailSegue {
            guard let vc = segue.destination as? ClubDetailViewController else { return }
            vc.clubInfo = sender as? Club
            vc.isFromCreateClub = true
        }
    }
}
