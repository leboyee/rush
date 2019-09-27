//
//  CreateEventInterestViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol EventInterestDelegate: class {
    func selectedInterest(_ interest: [String])
}

class CreateEventInterestViewController: CustomViewController {

    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var nextButton: CustomButton!
    var interestArray = [Interest]()
    var selectedArray = [String]()
    weak var delegate: EventInterestDelegate?

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
        setupMediator()
        getInterestList()
    }
    
    func setupUI() {

        // Set Custom part of Class
        setCustomNavigationBarView()
        nextButton.layer.cornerRadius = 8.0
        nextButton.clipsToBounds = true

    }
    
    // Custom navigation
    func setCustomNavigationBarView() {
        let customView = UIView(frame: CGRect(x: 24, y: 0, width: screenWidth - 72, height: 44))
        let label = UILabel(frame: CGRect(x: 0, y: 2, width: screenWidth - 72, height: 30))
        label.text = "Search interests"
        label.font = UIFont.displayBold(sz: 24)
        label.textColor = UIColor.navBarTitleWhite32
        customView.addSubview(label)
        navigationItem.titleView = customView
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
}

// MARK: - Other Function
extension CreateEventInterestViewController {
}

// MARK: - Actions
extension CreateEventInterestViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButtonAction() {
        if delegate != nil {
            navigationController?.popViewController(animated: true)
            DispatchQueue.main.async { [unowned self] () in
                self.delegate?.selectedInterest(self.selectedArray)
            }
        } else {
            Utils.alert(message: "In development")
        }

    }
}

// MARK: - Mediator
extension CreateEventInterestViewController {
    func interestButtonVisiable() {
        nextButton.isHidden = selectedArray.count > 0 ? false : true
    }
}
