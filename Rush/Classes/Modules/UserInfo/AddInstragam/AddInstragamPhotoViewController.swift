//
//  AddInstragamPhotoViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import WebKit

class AddInstragamPhotoViewController: CustomViewController {

    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var connectButton: CustomButton!
    
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
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones5.rawValue {
        }
    }
    
    // MARK: - Setup
    func setup() {
        setupUI()
    }
    
    func setupUI() {

        // Set Custom part of Class
        connectButton.layer.cornerRadius = 8.0
        connectButton.clipsToBounds = true
        setCustomNavigationBarView()
    }
    
    // Custom navigation Title View
    func setCustomNavigationBarView() {
        
        let gotProfileButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 128, height: 36))
        gotProfileButton.setImage(UIImage(named: "goToProfileButton"), for: .normal)
        gotProfileButton.addTarget(self, action: #selector(gotProfileButtonAction), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: gotProfileButton)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
}

// MARK: - Other Function
extension AddInstragamPhotoViewController {

}

// MARK: - Actions
extension AddInstragamPhotoViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
     @objc func gotProfileButtonAction() {
        AppDelegate.shared?.setupStoryboard()
        Utils.saveDataToUserDefault("ShowHomeTutorial", kHomeTutorialKey)
    }

    @IBAction func connectButtonAction() {
        self.performSegue(withIdentifier: "InstaWebViewSegue", sender: self)
    }
}

// MARK: - Navigation
extension AddInstragamPhotoViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.inviteContactSegue {
//            if let vc = segue.destination as? ContactsListViewController {
//            }
        }
    }
}
