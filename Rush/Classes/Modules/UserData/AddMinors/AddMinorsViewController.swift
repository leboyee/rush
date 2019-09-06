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

    var selectedArray = [String]()
    var minorArray = [[String: Any]]()
    var selectedIndex = -1
    var customMinorArray = [[String: Any]]()
    
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
        pageControllerView.frame = CGRect(x: -112, y: 0, width: screenWidth - 50, height: 50)
        
        customView.addSubview(pageControllerView)
        self.navigationItem.titleView = customView
        
        let skipButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 76, height: 35))
        skipButton.setImage(UIImage(named: "skipButton"), for: .normal)
        skipButton.addTarget(self, action: #selector(skipButtonAction), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: skipButton)
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
        var dict = [String: Any]()
        dict["name"] = searchTextField.text
        selectedArray.append(searchTextField.text ?? "")
        customMinorArray.append(dict)
        searchTextField.text = ""
        getMinorList(searchText: "")
        self.tableView.reloadData()
    }
    
    @IBAction func deleteButtonAction() {
        searchTextField.text = ""
        deleteButton.isHidden = true
        self.minorCustomButton.isHidden = true
    }
}

// MARK: - Preseneter
extension AddMinorsViewController {
    
    func profileUpdateSuccess() {
        self.performSegue(withIdentifier: Segues.chooseClassesViewSegue, sender: self)
    }
}
