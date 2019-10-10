//
//  PostViewController.swift
//  Rush
//
//  Created by ideveloper on 25/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol PostViewProtocol: class {
    func deletePostSuccess(_ post: Post?)
    func updatedPost(_ post: Post)
}

class PostViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var textBgView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomView: CustomView!
    
    weak var delegate: PostViewProtocol?
    
    var commentList = [Comment]()
    var parentComment: Comment?
    var imageList = [Any]()
    
    var commentText = ""
    var username = ""
    
    var clubInfo: Club?
    var eventInfo: Event?
    var postInfo: Post?
    var isFromCreatePost = false
    var pageNoP = 1
    var isNextPageExistP = false
    var pageNoC = 1
    var isNextPageExistC = false
    var updateCommentCount = 0
    var finishCommentCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    func setupUI() {
        
        bottomView.setBackgroundColor()
        navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.bgBlack
        
        // share button
        if postInfo?.user?.userId == Authorization.shared.profile?.userId {
            let share = UIBarButtonItem(image: #imageLiteral(resourceName: "whiteMore"), style: .plain, target: self, action: #selector(shareButtonAction))
            navigationItem.rightBarButtonItem = share
        } else {
            let share = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(shareButtonAction))
            navigationItem.rightBarButtonItem = share
        }
        
        // comment textview
        textView.placeHolder = "Aa"
        textView.delegate = self
        textBgView.backgroundColor = UIColor.lightGray93
        textBgView.layer.cornerRadius = textBgView.frame.size.height / 2
        
        setupTableView()
        
        // For test
        if imageList.count == 0 {
            imageList.append(UIImage(named: "bound-add-img")!)
        }
        
        getAllCommentListAPI()
    }
}

// MARK: - Actions
extension PostViewController {
    @objc func shareButtonAction() {
        performSegue(withIdentifier: Segues.sharePostSegue, sender: nil)
    }
    
    @IBAction func sendButtonAction() {
        if commentText.count > 0 {
            addCommentAPI()
            textView.resignFirstResponder()
        }
    }
}

// MARK: - Navigation
extension PostViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.sharePostSegue {
            if let vc = segue.destination as? SharePostViewController {
                vc.delegate = self
            }
        } else if segue.identifier == Segues.otherUserProfile {
            if let vc = segue.destination as? OtherUserProfileController {
                vc.clubImage = #imageLiteral(resourceName: "bound-add-img")
                vc.delegate = self
            }
        }
    }
}
