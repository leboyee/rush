//
//  AddInviteViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


class AddInviteViewController: CustomViewController {

    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var inviteContactButton: CustomButton!
    @IBOutlet weak var inviteFbButton: CustomButton!
    
    
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
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones5.rawValue  {
        }
    }
    
    
    //MARK: - Setup
    func setup() {
        setupUI()
    }
    
    func setupUI() {

        // Set Custom part of Class
        inviteContactButton.layer.cornerRadius = 8.0
        inviteContactButton.clipsToBounds = true
        inviteFbButton.layer.cornerRadius = 8.0
        inviteFbButton.clipsToBounds = true
        
        setCustomNavigationBarView()
    }

    
    // Custom navigation Title View
    func setCustomNavigationBarView() {
        
        let skipButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 76, height: 35))
        skipButton.setImage(UIImage(named: "skipButton"), for: .normal)
        skipButton.addTarget(self, action:  #selector(skipButtonAction), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: skipButton)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        
    }
}

//MARK: - Other Function
extension AddInviteViewController {

   
}

// MARK: - Actions
extension AddInviteViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
     @objc func skipButtonAction() {
        self.performSegue(withIdentifier: Segues.addInstagramPhotoViewSegue, sender: self)
    }

    @IBAction func inviteContactButtonAction() {
        self.performSegue(withIdentifier: Segues.inviteContactSegue, sender: self)
    }
    
    @IBAction func finisheRegistrationButtonAction() {
        AppDelegate.shared?.setupStoryboard()
    }
}

// MARK: - Navigation
extension AddInviteViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.inviteContactSegue {
            if let vc = segue.destination as? ContactsListViewController {
                vc.isFromRegister = true
                
            }
        }

    }
    
}
