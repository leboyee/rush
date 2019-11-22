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
    @IBOutlet weak var viewBottamConstraint: NSLayoutConstraint!
    
    weak var delegate: PostViewProtocol?
    
    var commentList = [Comment]()
    var parentComment: Comment?
    var imageList = [Any]()
    
    var commentText = ""
    var username = ""
    
    var clubInfo: Club?
    var eventInfo: Event?
    var subclassInfo: SubClass?
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
        navigationController?.isNavigationBarHidden = false
        IQKeyboardManager.shared.enable = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        
        // Notification's of keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if UIDevice.current.hasNotch {
            let bottomPadding = self.view?.safeAreaInsets.bottom
            viewBottamConstraint.constant = -(bottomPadding ?? 0)
        }
        getPostDetailAPI()
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

// MARK: - Keyboard delegates
extension PostViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            var keyboardHeight = keyboardRectangle.height
            if tabBarController?.tabBar.isHidden == false {
                keyboardHeight -= tabBarController?.tabBar.frame.height ?? 0
            }
            
            UIView.animate(withDuration: 0.8) {
                self.viewBottamConstraint.constant = keyboardHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        viewBottamConstraint.constant = 8
    }
}

// MARK: - Navigation
extension PostViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.sharePostSegue {
            if let vc = segue.destination as? SharePostViewController {
                vc.delegate = self
                vc.object = postInfo
            }
        } else if segue.identifier == Segues.otherUserProfile {
            if let vc = segue.destination as? OtherUserProfileController {
                if let id = sender as? Int64 {
                    let user = User()
                    user.id = id
                    vc.userInfo = user
                }
                vc.delegate = self
            }
        }
    }
}
