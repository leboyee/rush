//
//  PostViewController.swift
//  Rush
//
//  Created by ideveloper on 25/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PostViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var textBgView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomView: CustomView!
    
    var commentList = [String]()
    var imageList = [Any]()
    
    var commentText = ""
    var username = ""
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingToParent {
            navigationController?.popViewController(animated: false)
        }
    }
    
    func setupUI() {
        
        bottomView.setBackgroundColor()
        navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.bgBlack
        
        // share button
        let share = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(shareButtonAction))
        navigationItem.rightBarButtonItem = share
        
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
        commentList = ["1", "2", "3"]
    }
}

// MARK: - Actions
extension PostViewController {
    @objc func shareButtonAction() {
        performSegue(withIdentifier: Segues.sharePostSegue, sender: nil)
    }
    
    @IBAction func sendButtonAction() {
        if commentText.count > 0 {
            username = ""
            textView.text = ""
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
