//
//  CreateClubViewController.swift
//  Rush
//
//  Created by ideveloper on 20/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

class ClubDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: RBackgoundView!
    @IBOutlet weak var heightConstraintOfHeader: NSLayoutConstraint!
    @IBOutlet weak var clubHeader: ClubHeader!
    
    var interestList = [String]()
    var peopleList = [String]()
    var clubPostList = [Post]()
    
    var clubImage: UIImage = #imageLiteral(resourceName: "bound-add-img")
    
    var isReadMore = false
    var joinedClub = false
    
    var clubInfo: Club?
    var isMyClub = false
    var isFromCreateClub = false
    var isCallAPI = true
    
    let headerFullHeight: CGFloat = 367
    let headerSmallWithDateHeight: CGFloat = 182
    let headerSmallWithoutDateHeight: CGFloat = 114
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        // fetch club detail (Flag for come from create post = false otherwise true)
        if isCallAPI {
            getClubDetailAPI()
        } else {
            isCallAPI = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        if self.isMovingFromParent && isFromCreateClub {
            navigationController?.popViewController(animated: false)
        }
    }
    
    //MARk: - Other function
    func setup() {
        setupUI()
    }
    
    func setupUI() {
        
        // Check this club is created by me(logged in user)
        let clubId = clubInfo?.clubUId ?? "id"
        let userId = Authorization.shared.profile?.userId ?? ""
        if userId == clubId {
            joinedClub = true
        }
        
        // setup tableview
        setupTableView()
    }
}

// MARK: - Actions
extension ClubDetailViewController {
    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func shareButtonAction() {
        performSegue(withIdentifier: Segues.sharePostSegue, sender: nil)
    }
}

// MARK: - Navigation
extension ClubDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.otherUserProfile {
            if let vc = segue.destination as? OtherUserProfileController {
                // image for test
                vc.clubImage = clubImage
                vc.userInfo = sender as? User
                vc.delegate = self
            }
        } else if segue.identifier == Segues.sharePostSegue {
            if let vc = segue.destination as? SharePostViewController {
                vc.type = .club
            }
        } else if segue.identifier == Segues.createPost {
            guard let vc = segue.destination as? CreatePostViewController else { return }
            vc.clubInfo = clubInfo
            vc.delegate = self
        } else if segue.identifier == Segues.postSegue {
            if let vc = segue.destination as? PostViewController {
                vc.postInfo = sender as? Post
                vc.clubInfo = clubInfo
                vc.delegate = self
            }
        }
    }
}
