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
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "active-create"), style: .plain, target: self, action: #selector(createButtonAction))
        navigationItem.rightBarButtonItem = rightBarButton
        
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
