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
    
    var selectedIndex: Int? = -1
    var currentIndex: Int = 1
    let layout = UICollectionViewFlowLayout()
    var selectedImage: UIImage? = UIImage(contentsOfFile: "")
    var imageArray = [String]()
    var userPhoto = ""
    var userName = ""
    var timeString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.bgBlack
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(moreButtonAction))
        
//        navigationItem.titleView = Utils.getNavigationBarTitle(title: titleName, textColor: UIColor.white)

        // Setup tableview
        setupCollectionView()
        fillBottomProfile("Alex", "10 Pm")
    }
    
    // MARK: - Set Profile Data
    func fillBottomProfile(_ profileName:String, _ time:String) {
        userNameLable.text = profileName
        timeLable.text = time
        let imageStr = "https://tineye.com/images/widgets/mona.jpg"
        profilePicImageView.sd_setImage(with: URL(string: imageStr), completed: nil)
    }
    
     // MARK: - Actions
    @objc func moreButtonAction() {
        self.openShareSheet()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Setup Title
    func setTitle(titleStr: String) {
        titleLable.text = titleStr
    }
    
}
