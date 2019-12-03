//
//  UserProfileGalleryViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 04/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class UserProfileGalleryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var titleLable: UILabel!

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var profileImageButton: UIButton!

    var selectedIndex: Int? = -1
    var currentIndex: Int = 1
    let layout = UICollectionViewFlowLayout()
    var selectedImage: UIImage? = UIImage(contentsOfFile: "")
    var list = [Image]()
    var user = User()
    let downloadQueue = DispatchQueue(label: "com.messapps.profileImages")
    let downloadGroup = DispatchGroup()
    var imagePageNo: Int = 1
    var imageNextPageExist = false
    var isFromChat = false
    var isFromOtherUserProfile = false
    var userId: String = ""
    var totalCount: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //if selectedIndex != -1 {
        scrollToItemIndex(layout, currentIndex )
       // }
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "whiteMore"), style: .plain, target: self, action: #selector(moreButtonAction))
        
//        navigationItem.titleView = Utils.getNavigationBarTitle(title: titleName, textColor: UIColor.white)

        // Setup tableview
        setupCollectionView()
        fillBottomProfile()
        if isFromChat {
            setTitle(titleStr: "")
        } else {
            setTitle(titleStr: "\(currentIndex + 1) of \(totalCount)")
        }
        setupDateAndTimeOfPhoto(index: currentIndex)

        if isFromOtherUserProfile {
            bottomView.isHidden = true
        } else {
            bottomView.isHidden = false
        }
    }
    
    // MARK: - Set Profile Data
    func fillBottomProfile() {
        userNameLable.text = user.name
        profilePicImageView.sd_setImage(with: URL(string: user.photo?.thumb ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder-profile-48px"))
    }
    
     // MARK: - Actions
    @objc func moreButtonAction() {
        self.openShareSheet()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //navigationController?.popViewController(animated: true)
    }
    
    @IBAction func moreButtonAction(_ sender: Any) {
        openShareSheet()
      }
    
    @IBAction func profileButtonAction(_ sender: Any) {
        self.dismiss(animated: true) {
            var dict = [String: Any]()
            dict["user"] = self.user
            NotificationCenter.default.post(name: Notification.Name.userProfile, object: nil, userInfo: dict)
        }
    }
    // MARK: - Setup Title
    func setTitle(titleStr: String) {
        titleLable.text = titleStr
    }
    
    func setupDateAndTimeOfPhoto(index: Int) {
        if index < list.count {
            let image = list[index]
            
            if let date = image.date {
                if date.isSameDate(Date()) {
                    timeLable.text = date.toString(format: "hh:mm a")
                } else {
                    timeLable.text = date.toString(format: "MM-dd-yyyy")
                }
            }
        }
    }
    
}

// MARK: - Navigation
extension UserProfileGalleryViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.photoModelViewSegue {
            guard let vc = segue.destination as? PhotoModelViewController else { return }
            vc.delegate = self
            let image = list[currentIndex]
            vc.isFromOtherUserProfile = image.isInstaImage == true ? true : isFromOtherUserProfile
        }
    }
}
