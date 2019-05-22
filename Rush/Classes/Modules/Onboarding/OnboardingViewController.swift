//
//  OnboardingViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: CustomImagePageControl!
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var createButtonHeightConstratit: NSLayoutConstraint!
    @IBOutlet weak var pageControllerTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue  {
            createButtonHeightConstratit.constant =  35
            pageControllerTopConstraint.constant = 0
        }
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones_6_6s_7_8.rawValue  {
            createButtonHeightConstratit.constant =  40
            pageControllerTopConstraint.constant = 10
        }

        self.collectionView.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    func setUpUI() {
        setupMediator()
    }

}

// MARK: - Actions
extension OnboardingViewController {
    @objc func createButtonAction() {
        performSegue(withIdentifier: Segues.createClub/*Segues.selectEventType*/, sender: nil)
    }
}


// MARK: - Navigation
extension OnboardingViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.selectEventType {
            if let vc = segue.destination as? SelectEventTypeViewController {
                vc.type = .eventCategory
            }
        }
    }
    
}
