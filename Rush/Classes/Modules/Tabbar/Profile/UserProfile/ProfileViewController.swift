//
//  ProfileViewController.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

struct ProfileDetail {
    var profile: Profile?
    var images: [Image]?
    var friends: [Any]?
    var interests: [Any]?
    var notifications: [Any]?
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var header: ParallaxHeader!

    var profileDetail = ProfileDetail()
    let headerFullHeight: CGFloat = 344
    let headerSmallHeight: CGFloat = 126

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.isNavigationBarHidden = true
        title = ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

}

//MARK: - Setup
extension ProfileViewController {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
     
        setupTableView()
    }
    
}

extension ProfileViewController {
    
}
