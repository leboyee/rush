//
//  CreateClubViewController.swift
//  Rush
//
//  Created by Chirag on 20/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Photos

class ClassDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraintOfTableView: NSLayoutConstraint!
    
    var interestList = [String]()
    var peopleList = [String]()
    var classesPostList = [Post]()

    var timeList: [String] = ["Thursday", "Friday", "Sunday", "Tuesday", "Wednesday"]
    
    var clubImage: UIImage?
    
    var isShowMore = false
    var joinedClub = false
    
    var classInfo: Class?
    var subclassInfo: SubClass?
    var selectedGroup: ClassGroup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.barTintColor = UIColor.clear
        navigationController?.navigationBar.isTranslucent = true
        
        var classId = "0"
        var groupId = "0"
        if (subclassInfo?.myJoinedClass?.count ?? 0 > 0) {
            let joinedClass = subclassInfo?.myJoinedClass?[0]
            classId = joinedClass?.classId ?? "0"
            groupId = joinedClass?.groupId ?? "0"
        } else {
            classId = selectedGroup?.classId ?? "0"
            groupId = selectedGroup?.id ?? "0"
        }
        if (classId != "0" && groupId != "0") {
            getClassDetailAPI(classId: classId, groupId: groupId)
            getClassPostListAPI()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.bgBlack
        navigationController?.navigationBar.barTintColor = UIColor.bgBlack
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: - Other function
    func setup() {
        
        setupUI()
    }
    
    func setupUI() {
        
        /*
         let total = screenWidth + 15
         heightConstraintOfImageView.constant = total
         
         scrollView.contentInset = UIEdgeInsets(top: (total - Utils.navigationHeigh)*0.81, left: 0, bottom: 0, right: 0)
         */
        
        topConstraintOfTableView.constant = -Utils.navigationHeigh
        
        // share button
        let share = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(shareButtonAction))
        navigationItem.rightBarButtonItem = share
        
        /*
         // back button
         let cancel = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(cancelButtonAction))
         navigationItem.leftBarButtonItem = cancel
         */
        
        // setup tableview
        setupTableView()
    }
}

// MARK: - Actions
extension ClassDetailViewController {
    @IBAction func cancelButtonAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func shareButtonAction() {
        performSegue(withIdentifier: Segues.sharePostSegue, sender: nil)
    }
}

// MARK: - Navigation
extension ClassDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segues.otherUserProfile {
            if let vc = segue.destination as? OtherUserProfileController {
                // image for test
                vc.clubImage = clubImage
                vc.delegate = self
            }
        } else if segue.identifier == Segues.sharePostSegue {
            if let vc = segue.destination as? SharePostViewController {
                vc.type = .classes
                vc.post = sender as? Post
            }
        } else if segue.identifier == Segues.createPost {
            if let vc = segue.destination as? CreatePostViewController {
                vc.subclassInfo = subclassInfo
                vc.delegate = self
            }
        } else if segue.identifier == Segues.postSegue {
            if let vc = segue.destination as? PostViewController {
                vc.postInfo = sender as? Post
                vc.subclassInfo = subclassInfo
                vc.delegate = self
            }
        }
    }
}
