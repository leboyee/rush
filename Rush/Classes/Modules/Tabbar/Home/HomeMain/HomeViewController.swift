//
//  HomeViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class HomeViewController: CustomViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isShowTutorial = true
    var isShowJoinEvents = false
    
    var date = "January 24"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
        
        setupNavigation()
    }
    
    func setupNavigation() {
        
        // Right item button
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "active-create"), style: .plain, target: self, action: #selector(createButtonAction))
        navigationItem.rightBarButtonItem = rightBarButton
        
        /*
        // create the button
        let createImage  = UIImage(named: "active-create")!.withRenderingMode(.alwaysOriginal)
        let createButton = UIButton(frame: CGRect(x: 0, y: 0, width: 78, height: 36))
        createButton.setBackgroundImage(createImage, for: .normal)
        createButton.addTarget(self, action: #selector(createButtonAction), for:.touchUpInside)
        
        // here where the magic happens, you can shift it where you like
        createButton.transform = CGAffineTransform(translationX: -5, y: 5)
        
        // add the button to a container, otherwise the transform will be ignored
        let createButtonContainer = UIView(frame: createButton.frame)
        createButtonContainer.addSubview(createButton)
        let createButtonItem = UIBarButtonItem(customView: createButtonContainer)
        
        // add button shift to the side
        navigationItem.rightBarButtonItem = createButtonItem
        */
 
        // Set navigation title (date)
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth - 130, height: 59))
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth - 130, height: 30))
        dateLabel.text = date
        dateLabel.font = UIFont.DisplayBold(sz: 24)
        dateLabel.textColor = UIColor.white
        
        // View calender button setup
        let viewCalender = UIButton(frame: CGRect(x: -10, y: 30, width: 100, height: 18))
        viewCalender.setTitle("View calendar", for: .normal)
        viewCalender.titleLabel?.textAlignment = .left
        viewCalender.setTitleColor(UIColor.gray47, for: .normal)
        viewCalender.titleLabel?.font = UIFont.DisplaySemibold(sz: 13)
        navigationView.addSubview(dateLabel)
        navigationView.addSubview(viewCalender)
        navigationItem.titleView = navigationView
    }
    
    func openCreateClubViewController() {
        performSegue(withIdentifier: Segues.createClub, sender: nil)
    }
}

// MARK: - Actions
extension HomeViewController {
    @objc func createButtonAction() {
        // Segues.createClub
        // Segues.selectEventType
        performSegue(withIdentifier: Segues.openPostScreen, sender: nil)
    }
}



// MARK: - Navigation
extension HomeViewController {
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.selectEventType {
            if let vc = segue.destination as? SelectEventTypeViewController {
                vc.type = .eventCategory
                vc.delegate = self
            }
        }
     }
    
}
