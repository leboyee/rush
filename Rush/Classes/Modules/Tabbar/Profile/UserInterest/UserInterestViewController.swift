//
//  UserInterestViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class UserInterestViewController: CustomViewController {

    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: CustomButton!
    var interestArray = [Interest]()
    var searchArray = [Interest]()
    var isSearch = false
    weak var delegate: EventInterestDelegate?
    var rightBarButton: UIBarButtonItem?
    var searchTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        interestArray = Authorization.shared.profile?.interest ?? [Interest]()
        tableView.reloadData()
        interestButtonVisiable()

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
    }
    
    func setupUI() {

        // Set Custom part of Class
        setCustomNavigationBarView()
        nextButton.layer.cornerRadius = 8.0
        nextButton.clipsToBounds = true
        nextButton.isHidden = false
    }
    
    // Custom navigation
    func setCustomNavigationBarView() {
        let customView = UIView(frame: CGRect(x: 48, y: 0, width: screenWidth - 48, height: 44))
        
            searchTextField = UITextField(frame: CGRect(x: 0, y: -3, width: screenWidth - 48, height: 44))
            searchTextField?.font = UIFont.displayBold(sz: 24)
            searchTextField?.textColor = UIColor.white
            searchTextField?.returnKeyType = .go
            searchTextField?.autocorrectionType = .no
            searchTextField?.delegate = self
            let font = UIFont.displayBold(sz: 24)
            let color = UIColor.navBarTitleWhite32
            searchTextField?.attributedPlaceholder = NSAttributedString(string: "Search interests", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
            searchTextField?.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        customView.addSubview(searchTextField ?? UIView())
            navigationItem.titleView = customView
        
        self.rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "plus_white"), style: .plain, target: self, action: #selector(plusButtonAction))
        self.navigationItem.rightBarButtonItem = self.rightBarButton
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
}

// MARK: - Other Function
extension UserInterestViewController {
}

// MARK: - Actions
extension UserInterestViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButtonAction() {
        updateProfileAPI()
    }
    @objc func plusButtonAction() {
        if isSearch == true {
            searchTextField?.text = ""
            self.tableView.reloadData()
            isSearch = false
            rightBarButton?.image = #imageLiteral(resourceName: "plus_white")
        } else {
            self.performSegue(withIdentifier: Segues.addInterestViewSegue, sender: self)
        }
    }
}

// MARK: - Mediator
extension UserInterestViewController {
    func interestButtonVisiable() {
        nextButton.isHidden = interestArray.count > 2 ? false : true
    }
}

// MARK: - Preseneter
extension UserInterestViewController {
    func profileUpdateSuccess() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Navigation
extension UserInterestViewController {
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == Segues.addInterestViewSegue {
            if let vc = segue.destination as? AddInterestViewController {
                vc.selectedArray = interestArray
            }
        }
     }
}
