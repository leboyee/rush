//
//  AddMinorsViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AddMinorsViewController: CustomViewController {

    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var pageControllerView: UIView!
    @IBOutlet weak var pageControl: CustomImagePageControl!
    @IBOutlet weak var pageControllerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var minorCustomButton: UIButton!
    @IBOutlet weak var minorButtonConstraint: NSLayoutConstraint!
    var isEditUserProfile: Bool = false
    var selectedArray = [String]()
    var isSearch = false
    var minorArray = [[String: Any]]()
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        searchTextField.autocorrectionType = .no
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        if isEditUserProfile == true {
            pageControl.isHidden = true
            self.navigationItem.rightBarButtonItem = nil
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewWillLayoutSubviews() {
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones5.rawValue {
        }
    }
    
    // MARK: - Setup
    func setup() {
        setupUI()
        setupMediator()
        getMinorList(searchText: "")
    }
    
    func setupUI() {

        // Set Custom part of Class
        self.bgImageView.setBgForLoginSignup()
        setCustomNavigationBarView()
        self.nextButton.setNextButton(isEnable: true)
        bottomView.isHidden = true
        deleteButton.isHidden = true
        minorCustomButton.isHidden = true
        minorCustomButton.layer.cornerRadius = 8.0
        minorCustomButton.clipsToBounds = true
    }
    
    // Custom navigation Title View
    func setCustomNavigationBarView() {

        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: 50)
        let customView = UIView(frame: frame)
        pageControl.isSteps = true
        pageControl.updateDots()
        pageControllerView.frame = CGRect(x: Utils.systemVersionEqualToOrGreterThen(version: "13") ? Utils.isiPhone5() ? -30 : 0 : -112, y: 0, width: screenWidth - 50, height: 50)

        customView.addSubview(pageControllerView)
        self.navigationItem.titleView = customView
        
        let skipButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 76, height: 35))
        skipButton.setImage(UIImage(named: "skipButton"), for: .normal)
        skipButton.addTarget(self, action: #selector(skipButtonAction), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: skipButton)
        
//        if(isEditProfile == true) {
//            pageControl.isHidden = true
//            self.navigationItem.rightBarButtonItem = nil
//        }
    }
}

// MARK: - Other Function
extension AddMinorsViewController {
    func moveToNext() {
        bottomView.isHidden = self.selectedArray.count > 0 ? false : true
        self.tableView.reloadData()
    }
}

// MARK: - Actions
extension AddMinorsViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func skipButtonAction() {
        self.performSegue(withIdentifier: Segues.chooseClassesViewSegue, sender: self)
        //AppDelegate.getInstance().setupStoryboard()
    }

    @IBAction func nextButtonAction() {
        updateProfileAPI()
       //AppDelegate.getInstance().setupStoryboard()
    }
    
    @IBAction func addCustomMinoreButtonAction() {
        if searchTextField.text?.isEmpty == false {
            isSearch = false
            var dict = [String: Any]()
                 dict["name"] = searchTextField.text
            selectedArray.insert(searchTextField.text ?? "", at: 0)
                 //selectedArray.append(searchTextField.text ?? "")
                 searchTextField.text = ""
                 getMinorList(searchText: "")
                 self.minorCustomButton.isHidden = true
                deleteButton.isHidden = true
                 self.view.endEditing(true)
                self.moveToNext()
                 self.tableView.reloadData()
        }
     
    }
    
    @IBAction func deleteButtonAction() {
        searchTextField.text = ""
        isSearch = false
        deleteButton.isHidden = true
        self.minorCustomButton.isHidden = true
        getMinorList(searchText: "")

    }
}

// MARK: - Preseneter
extension AddMinorsViewController {
    
    func profileUpdateSuccess() {
        if isEditUserProfile == true {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.performSegue(withIdentifier: Segues.chooseClassesViewSegue, sender: self)
        }
    }
}
