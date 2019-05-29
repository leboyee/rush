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
    
    var cancelBtn : UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "cancel-active"), style: .plain, target: self, action: #selector(cancelButtonAction))
    }
    
    var saveBtnActive : UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "save-active"), style: .plain, target: self, action: #selector(saveButtonAction))
    }
    
    var saveBtnDisActive : UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "save-dark"), style: .plain, target: self, action: nil)
    }
    
    var interestList = [String]()
    var peopleList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.barTintColor = UIColor.black
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
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.isTranslucent = true
        navigationBarAppearance.barTintColor = UIColor.clear
        navigationBarAppearance.setBackgroundImage(UIImage(), for: .default)
        
        navigationItem.leftBarButtonItem = cancelBtn
        
        if userImageView.image != nil {
            addPhotoButton.isHidden = true
            navigationItem.rightBarButtonItem = saveBtnActive
        } else {
            hoverView.isHidden = true
            addPhotoButton.isHidden = false
           navigationItem.rightBarButtonItem = saveBtnDisActive
        }
        setupTableView()
    }
}

//MARK: - Actions
extension CreateClubViewController {
    @IBAction func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonAction() {
        performSegue(withIdentifier: Segues.myClub, sender: nil)
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
