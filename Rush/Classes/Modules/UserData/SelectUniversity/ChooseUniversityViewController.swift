//
//  ChooseUniversityViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol ChooseUnivesityDelegate: class {
    func selectedUniversity(_ university: University)
}

class ChooseUniversityViewController: CustomViewController {

    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var pageControllerView: UIView!
    @IBOutlet weak var pageControl: CustomImagePageControl!
    @IBOutlet weak var pageControllerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var noResultView: UIView!

    var universityArray = [University]()
    var selectedIndex = -1
    var addUniversityType: AddUniversityType = .register
    var pageNo: Int = 1
    var isNextPageExist: Bool = false
    weak var delegate: ChooseUnivesityDelegate?
    var task: URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        if addUniversityType == .editProfile || addUniversityType == .createEvent {
            pageControl.isHidden = true
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       
    }
    
    override func viewWillLayoutSubviews() {
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones5.rawValue {
        }
    }
    
    // MARK: - Setup
    func setup() {
        setupUI()
        setupMediator()
        getUniversity(searchText: "")
    }
    
    func setupUI() {

        // Set Custom part of Class
        self.bgImageView.setBgForLoginSignup()
        setCustomNavigationBarView()
        deleteButton.isHidden = true
        noResultView.isHidden = true
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
        
//            if(isEditProfile == true) {
//                pageControl.isHidden = true
//                self.navigationItem.rightBarButtonItem = nil
//            }
    }
}

// MARK: - Other Function
extension ChooseUniversityViewController {
    func moveToNext() {
        if self.addUniversityType == .createEvent {
            let university = universityArray[selectedIndex]
            self.delegate?.selectedUniversity(university)
            self.navigationController?.popViewController(animated: true)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.updateProfileAPI()
            }
        }
    }
}

// MARK: - Actions
extension ChooseUniversityViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func skipButtonAction() {
        self.performSegue(withIdentifier: Segues.addMajorViewSegue, sender: self)
        //AppDelegate.getInstance().setupStoryboard()
    }
    
    @IBAction func addImageViewButtonAction() {
        
    }
    
    @IBAction func deleteButtonAction() {
        searchTextField.text = ""
        deleteButton.isHidden = true
        getUniversity(searchText: "")
    }

}

// MARK: - Preseneter
extension ChooseUniversityViewController {
    func profileUpdateSuccess() {
        if self.addUniversityType == .editProfile {
            self.navigationController?.popViewController(animated: true)
        } else {
            
            self.performSegue(withIdentifier: Segues.addMajorViewSegue, sender: self)
        }
    }
}
