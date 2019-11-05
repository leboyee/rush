//
//  AddInterestViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AddInterestViewController: CustomViewController {

    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var noResultView: UIView!

    var interestArray = [Interest]()
    var searchArray = [Interest]()
    var selectedArray = [Interest]()
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
        noResultView.isHidden = true
        self.getInterestList(searchText: "")
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
                
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        self.rightBarButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(plusButtonAction))
        self.navigationItem.rightBarButtonItem = self.rightBarButton
    }
}

// MARK: - Other Function
extension AddInterestViewController {
}

// MARK: - Actions
extension AddInterestViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButtonAction() {
        updateProfileAPI()
    }
    @objc func plusButtonAction() {
        if isSearch == true {
            searchTextField?.text = ""
            isSearch = false
            rightBarButton?.image = nil
            getInterestList(searchText: "")
        }
    }
}

// MARK: - Mediator
extension AddInterestViewController {
    func interestButtonVisiable() {
       // nextButton.isHidden = selectedArray.count > 0 ? false : true
    }
}

// MARK: - Preseneter
extension AddInterestViewController {
    func profileUpdateSuccess() {
        self.navigationController?.popViewController(animated: true)
    }
}
