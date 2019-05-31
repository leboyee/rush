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
        
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//
//        let rightBarButton = UIBarButtonItem(image: UIImage(named: "active-create"), style: .plain, target: self, action: #selector(createButtonAction))
//        navigationItem.rightBarButtonItem = rightBarButton
        
        
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
        performSegue(withIdentifier: Segues.selectEventType, sender: nil)
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
