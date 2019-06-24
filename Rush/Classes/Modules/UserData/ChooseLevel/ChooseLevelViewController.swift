//
//  ChooseLevelViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


class ChooseLevelViewController: CustomViewController {

    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var pageControllerView: UIView!
    @IBOutlet weak var bottomView: CustomView!
    @IBOutlet weak var skipLabel: CustomLabel!
    @IBOutlet weak var pageControl: CustomImagePageControl!
    @IBOutlet weak var pageControllerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var isSkip: Bool = false
    var selectedIndex = -1
    
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
        self.bottomView.setSkipBackgrounViewColor()
        self.skipLabel.setSkipLevelOnChooseLevelView()
        setCustomNavigationBarView()
        bottomView.layer.cornerRadius = 8.0
        bottomView.clipsToBounds = true
        skipLabel.text = Message.skipSavedImageMessage
        bottomView.isHidden = isSkip == true ? false : true
         //hide Skip Popup here
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.bottomView.isHidden = true
        }
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
extension ChooseLevelViewController {
    func moveToNext() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.selectedIndex > 2 {
                self.performSegue(withIdentifier: Segues.chooseUniverSitySegueFromLevelView, sender: self)
            }
            else {
                self.performSegue(withIdentifier: Segues.chooseYearSegue, sender: self)
            }
        }
    }
    
}

// MARK: - Actions
extension ChooseLevelViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func skipButtonAction() {
        self.performSegue(withIdentifier: Segues.chooseYearSegue, sender: self)

    }

    
    @IBAction func addImageViewButtonAction() {
        
    }
}

// MARK: - Navigation
extension ChooseLevelViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.chooseYearSegue {
            if let vc = segue.destination as? ChooseYearViewController {
            }
        }
    }
}
