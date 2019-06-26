//
//  PostViewController.swift
//  Rush
//
//  Created by ideveloper on 25/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var commentList = [String]()
    var imageList   = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        
        navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.bgBlack
        
        // share button
        let share = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(shareButtonAction))
        navigationItem.rightBarButtonItem = share
        
        setupTableView()
        
        // For test
        if imageList.count == 0 {
            imageList.append(UIImage(named: "bound-add-img")!)
        }
        commentList = ["1", "2"]
    }
}

// MARK: - Actions
extension PostViewController {
    @objc func shareButtonAction() {
        Utils.notReadyAlert()
    }
}

// MARK: - Navigation
extension PostViewController {
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }
     */
}
