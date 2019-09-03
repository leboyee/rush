//
//  ChooseUniversityViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


class UserInfoViewController: CustomViewController {

    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var pageControllerView: UIView!
    @IBOutlet weak var pageControl: CustomImagePageControl!
    @IBOutlet weak var pageControllerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var titleLabelOne: UILabel!
    @IBOutlet weak var titleLableTwo: UILabel!

    var selectedGender: Int = 0
    var selectedRelation: Int = 0
    
    var selectedIndex = -1
    var dob = ""
    var gender = ""
    var relation = ""
    var homeTown = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewWillLayoutSubviews() {
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue  {
            titleLabelOne.font = UIFont.Bold(sz: 24)
            titleLableTwo.font = UIFont.Bold(sz: 24)
        }
    }
    
    
    //MARK: - Setup
    func setup() {
        setupUI()
        setupMediator()
    }
    
    func setupUI() {

        // Set Custom part of Class
        self.bgImageView.setBgForLoginSignup()
        setCustomNavigationBarView()
        nextButton.setNextButton(isEnable: false)
    }

    
    // Custom navigation Title View
    func setCustomNavigationBarView() {
        

        let frame = CGRect(x: 0, y: 0, width: screenWidth , height: 50)
        let customView = UIView(frame: frame)
        pageControl.isSteps = true
        pageControl.updateDots()
        pageControllerView.frame = CGRect(x: -112, y: 0, width: screenWidth - 50 , height: 50)
        
        customView.addSubview(pageControllerView)
        self.navigationItem.titleView = customView
        
        let skipButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 76, height: 35))
        skipButton.setImage(UIImage(named: "skipButton"), for: .normal)
        skipButton.addTarget(self, action:  #selector(skipButtonAction), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: skipButton)
        
    }
}

//MARK: - Other Function
extension UserInfoViewController {

    func nextButtonEnabled() {
        if dob.isEmpty == false && gender.isEmpty == false && relation.isEmpty == false {
            self.nextButton.setNextButton(isEnable: true)
        }
        else {
            self.nextButton.setNextButton(isEnable: false)
        }
    }
}

// MARK: - Actions
extension UserInfoViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func skipButtonAction() {
        self.performSegue(withIdentifier: Segues.addInviteViewSegue, sender: self)
        //AppDelegate.getInstance().setupStoryboard()
    }

    
    @IBAction func finisheRegistrationButtonAction() {
        self.performSegue(withIdentifier: Segues.addInviteViewSegue, sender: self)
        //AppDelegate.getInstance().setupStoryboard()
    }
}
