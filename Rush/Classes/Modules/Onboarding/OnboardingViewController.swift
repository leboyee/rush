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
    var loginType: LoginType = .register
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones5.rawValue {
            createButtonHeightConstratit.constant =  35
            pageControllerTopConstraint.constant = 0
        }
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones6.rawValue {
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
        moveToStepView()
    }
    
    func moveToStepView() {
        let step = Authorization.shared.profile?.step
        if Authorization.shared.authorized == true {
            switch step {
            case 0:
                guard let userNameViewController = UIStoryboard(name: "UserData", bundle: nil).instantiateViewController(withIdentifier: "EnterUserNameViewController") as? EnterUserNameViewController else { return }
                self.navigationController?.pushViewController(userNameViewController, animated: false)
            case 1:
                guard let universityViewController = UIStoryboard(name: "UserData", bundle: nil).instantiateViewController(withIdentifier: "ChooseUniversityViewController") as? ChooseUniversityViewController else { return }
                universityViewController.addUniversityType = .register
                self.navigationController?.pushViewController(universityViewController, animated: false)
            case 2:
                guard let interestViewController = UIStoryboard(name: "UserData", bundle: nil).instantiateViewController(withIdentifier: "ChooseInterestViewController") as? ChooseInterestViewController else { return }
                self.navigationController?.pushViewController(interestViewController, animated: false)
            default:
                break
            }
        }
    }

}

// MARK: - Actions
extension OnboardingViewController {
    @IBAction func createButtonAction() {
        loginType = .register
        performSegue(withIdentifier: Segues.enterEmail, sender: self)
    }
    
    @IBAction func loginButtonAction() {
        loginType = .login
        performSegue(withIdentifier: Segues.enterEmail, sender: self)
    }
}

// MARK: - Navigation
extension OnboardingViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.enterEmail {
            if let vc = segue.destination as? EnterEmailViewConteroller {
                vc.loginType = loginType
            }
        }
    }
    
}
