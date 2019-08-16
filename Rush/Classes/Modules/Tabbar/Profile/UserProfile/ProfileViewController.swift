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
    var friends: [Friend]?
    var interests: [Tag]?
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
     
        //TODO: - Temp Data
        profileDetail.interests = [Tag(id: 01, text: "Games"), Tag(id: 03, text: "Technologies"), Tag(id: 04, text: "VR"), Tag(id: 05, text: "Development"), Tag(id: 06, text: "Swift")]
        
        let f1 = Friend()
        f1.firstName = "John"
        f1.photo = Image(url: "https://www.liulishenshe.com/Simplify_admin/images/profile/profile1.jpg")
        
        let f2 = Friend()
        f2.firstName = "Jame"
        f2.photo = Image(url: "https://www.liulishenshe.com/Simplify_admin/images/profile/profile4.jpg")
        
        let f3 = Friend()
        f3.firstName = "Elizabeth"
        f3.photo = Image(url: "https://www.liulishenshe.com/Simplify_admin/images/profile/profile7.jpg")
        
        let f4 = Friend()
        f4.firstName = "Sarah"
        f4.photo = Image(url: "https://www.liulishenshe.com/Simplify_admin/images/profile/profile5.jpg")
        
        let f5 = Friend()
        f5.firstName = "Karen"
        f5.photo = Image(url: "https://www.liulishenshe.com/Simplify_admin/images/profile/profile3.jpg")
        
        profileDetail.friends = [f1, f2, f3, f4, f5]
        
        setupTableView()
    }
    
}

extension ProfileViewController {
    
}
